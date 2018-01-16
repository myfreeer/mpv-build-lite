ExternalProject_Add(libmfx
    GIT_REPOSITORY https://github.com/lu-zero/mfx_dispatch.git
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX} -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE} -DBUILD_SHARED_LIBS=OFF -DENABLE_UBSAN=NO
    BUILD_COMMAND ${CMAKE_MAKE_PROGRAM}
    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(libmfx copy-headers
    DEPENDEES download
    DEPENDERS configure
    WORKING_DIRECTORY <SOURCE_DIR>
    COMMAND cp -rf mfx ${MINGW_INSTALL_PREFIX}/include/mfx
)

force_rebuild_git(libmfx)
extra_step(libmfx)
