cmake_minimum_required(VERSION 3.6.0)
project(mpv-cross C)
include(ExternalProject)
include(ProcessorCount)

if(NOT CMAKE_GENERATOR STREQUAL "Ninja")
    message(WARNING "Generator “${CMAKE_GENERATOR}” is unsupported!\nTry Ninja if you encounter problems.")
endif()

set(TARGET_ARCH "x86_64-w64-mingw32" CACHE STRING "The target architecture for this toolchain.")
string(REGEX MATCH "^[^-]+" TARGET_CPU ${TARGET_ARCH})

execute_process(COMMAND ${CMAKE_C_COMPILER} -dumpmachine OUTPUT_VARIABLE HOST_ARCH)
string(REGEX MATCH "^[^-]+" HOST_CPU ${HOST_ARCH})

if(TARGET_CPU MATCHES "x86_64")
    set(TARGET_CPU_FAMILY "x86_64")
    set(TARGET_BITS 64)
else()
    set(TARGET_CPU_FAMILY "x86")
    set(TARGET_BITS 32)
endif()

processorcount(CPU_COUNT)
if(CPU_COUNT EQUAL 0)
    set(CPU_COUNT 1)
endif()

set(MAKEJOBS ${CPU_COUNT})
# set(MAKEJOBS 5) # uncomment this line to manually change no. of cpu
set(MAKEJOBS ${MAKEJOBS} CACHE STRING "Number of parallel processes to run for each package build")

if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set (CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/install" CACHE PATH "Default install path" FORCE )
endif()
set(MINGW_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX}/mingw)

set(ENABLE_VCS_UPDATES true CACHE STRING "Enable automatic updates and forced rebuilds for packages built from git/svn sources")

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/scripts/toolchain.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/toolchain.cmake @ONLY)
set(TOOLCHAIN_FILE ${CMAKE_CURRENT_BINARY_DIR}/toolchain.cmake)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/scripts/meson_cross.txt.in ${CMAKE_CURRENT_BINARY_DIR}/meson_cross.txt @ONLY)
set(MESON_CROSS ${CMAKE_CURRENT_BINARY_DIR}/meson_cross.txt)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/scripts/exec.in ${CMAKE_CURRENT_BINARY_DIR}/exec @ONLY)
set(EXEC ${CMAKE_CURRENT_BINARY_DIR}/exec)
set(MAKE ${EXEC} make -j${MAKEJOBS})
set(DEBPATCH ${CMAKE_CURRENT_SOURCE_DIR}/scripts/debpatch)

string(TIMESTAMP BUILDDATE "%Y%m%d" UTC)

if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/scripts/publish.in)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/scripts/publish.in ${CMAKE_CURRENT_BINARY_DIR}/publish)
endif()

function(extra_step _name)
    set(stamp_dir ${CMAKE_CURRENT_BINARY_DIR}/${_name}-prefix/src/${_name}-stamp)

    ExternalProject_Add_Step(${_name} fullclean
        WORKING_DIRECTORY <SOURCE_DIR>
        COMMAND ${EXEC} find ${stamp_dir} -type f " ! -iname '*.cmake' " -size 0c -delete # remove 0 byte files which are stamp files
        ALWAYS TRUE
        EXCLUDE_FROM_MAIN TRUE
        COMMENT "Deleting all stamp files of ${_name} package"
    )

    ExternalProject_Add_Step(${_name} liteclean
        WORKING_DIRECTORY <SOURCE_DIR>
        COMMAND ${EXEC} rm -f ${CMAKE_CURRENT_BINARY_DIR}/${_name}-prefix/src/${_name}-stamp/${_name}-build
                              ${CMAKE_CURRENT_BINARY_DIR}/${_name}-prefix/src/${_name}-stamp/${_name}-install
        ALWAYS TRUE
        EXCLUDE_FROM_MAIN TRUE
        COMMENT "Deleting build, clean stamp files of ${_name} package"
    )
    ExternalProject_Add_StepTargets(${_name} fullclean liteclean)
endfunction()

function(force_rebuild_git _name)
    get_property(git_tag TARGET ${_name} PROPERTY _EP_GIT_TAG)
    if(NOT git_tag)
      set(git_tag "@{u}")
      set(pull COMMAND git pull)
    else()
      set(git_tag ${git_tag})
      set(pull "")
    endif()

    if(ENABLE_VCS_UPDATES)
        ExternalProject_Add_Step(${_name} force-update
            DEPENDEES download update
            DEPENDERS patch build install
            COMMAND git reset --hard ${git_tag}
            ${pull}
            WORKING_DIRECTORY <SOURCE_DIR>
            LOG 1
        )
    endif()
endfunction()

function(force_rebuild_svn _name)
    if(ENABLE_VCS_UPDATES)
        ExternalProject_Add_Step(${_name} force-update
            DEPENDEES download update
            DEPENDERS patch build install
            COMMAND svn revert -R .
            COMMAND svn up
            WORKING_DIRECTORY <SOURCE_DIR>
            LOG 1
        )
    endif()
endfunction()

function(force_rebuild_hg _name)
    if(ENABLE_VCS_UPDATES)
        ExternalProject_Add_Step(${_name} force-update
            DEPENDEES download update
            DEPENDERS patch build install
            COMMAND hg --config "extensions.purge=" purge --all
            COMMAND hg update -C
            WORKING_DIRECTORY <SOURCE_DIR>
            LOG 1
        )
    endif()
endfunction()

function(autogen _name)
    ExternalProject_Add_Step(${_name} autogen
        DEPENDEES download update patch
        DEPENDERS configure
        COMMAND ${EXEC} ./autogen.sh -V
        WORKING_DIRECTORY <SOURCE_DIR>
        LOG 1
    )
endfunction()

function(autoreconf _name)
    ExternalProject_Add_Step(${_name} autoreconf
        DEPENDEES download update patch
        DEPENDERS configure
        COMMAND ${EXEC} autoreconf -fi
        WORKING_DIRECTORY <SOURCE_DIR>
        LOG 1
    )
endfunction()

add_subdirectory(toolchain)
add_subdirectory(packages)
