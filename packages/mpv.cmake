ExternalProject_Add(mpv
    DEPENDS
        ffmpeg
        fribidi
        lcms2
        libarchive
        libass
        libdvdnav
        libdvdread
#        libiconv
        libjpeg
        libpng
        luajit
        rubberband
        uchardet
        openal-soft
        mujs
        vulkan
        libplacebo
    GIT_REPOSITORY https://github.com/mpv-player/mpv.git
    UPDATE_COMMAND ""
    PATCH_COMMAND ${EXEC} git revert -n a86b0ffa6b9a3c0717a337d2e5544365b6cda2ad COMMAND ${EXEC} git apply ${CMAKE_CURRENT_SOURCE_DIR}/mpv-*.diff
    CONFIGURE_COMMAND ${EXEC}
        PKG_CONFIG=pkg-config
        TARGET=${TARGET_ARCH}
        DEST_OS=win32
        <SOURCE_DIR>/waf configure
        --enable-static-build
        --enable-pdf-build
        --disable-manpage-build
        --enable-libmpv-shared
        --enable-lua
        --enable-javascript
        --enable-libarchive
        --enable-libass
        --enable-libbluray
        --enable-dvdnav
        --enable-uchardet
        --enable-rubberband
        --enable-lcms2
        --enable-openal
        --enable-spirv-cross
        --enable-vulkan
        --disable-egl-angle-lib
        --prefix=${MINGW_INSTALL_PREFIX}
    BUILD_COMMAND ${EXEC} <SOURCE_DIR>/waf
    INSTALL_COMMAND ""
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(mpv bootstrap
    DEPENDEES download
    DEPENDERS configure
    COMMAND <SOURCE_DIR>/bootstrap.py
    WORKING_DIRECTORY <SOURCE_DIR>
    LOG 1
)

ExternalProject_Add_Step(mpv strip-binary
    DEPENDEES build
    COMMAND ${EXEC} ${TARGET_ARCH}-objcopy --only-keep-debug <SOURCE_DIR>/build/mpv.exe <SOURCE_DIR>/build/mpv.debug
    COMMAND ${EXEC} ${TARGET_ARCH}-strip -s <SOURCE_DIR>/build/mpv.exe
    COMMAND ${EXEC} ${TARGET_ARCH}-objcopy --add-gnu-debuglink=<SOURCE_DIR>/build/mpv.debug <SOURCE_DIR>/build/mpv.exe
    COMMAND ${EXEC} ${TARGET_ARCH}-strip -s <SOURCE_DIR>/build/mpv.com
    COMMAND ${EXEC} ${TARGET_ARCH}-strip -s <SOURCE_DIR>/build/mpv-1.dll
    COMMENT "Stripping mpv binaries"
)

ExternalProject_Add_Step(mpv copy-binary
    DEPENDEES strip-binary
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/build/mpv.exe ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/mpv.exe
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/build/mpv.com ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/mpv.com
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/build/DOCS/man/mpv.pdf ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/doc/manual.pdf

    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/build/mpv.debug ${CMAKE_CURRENT_BINARY_DIR}/mpv-debug/mpv.debug

    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/build/mpv-1.dll ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/mpv-1.dll
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/build/mpv.dll.a ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/libmpv.dll.a
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/build/mpv.def ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/mpv.def
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/libmpv/client.h ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/include/client.h
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/libmpv/opengl_cb.h ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/include/opengl_cb.h
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/libmpv/stream_cb.h ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/include/stream_cb.h
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/libmpv/qthelper.hpp ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/include/qthelper.hpp
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/libmpv/render.h ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/include/render.h
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/libmpv/render_gl.h ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/include/render_gl.h

    COMMENT "Copying mpv binaries and manual"
)

set(RENAME ${CMAKE_CURRENT_BINARY_DIR}/mpv-prefix/src/rename.sh)
file(WRITE ${RENAME}
"#!/bin/bash
cd $1
GIT=$(git rev-parse --short=7 HEAD)
mv $2 $2-git-\${GIT}")

ExternalProject_Add_Step(mpv copy-package-dir
    DEPENDEES copy-binary
    COMMAND chmod 755 ${RENAME}
    COMMAND mv ${CMAKE_CURRENT_BINARY_DIR}/mpv-package ${CMAKE_BINARY_DIR}/mpv-${TARGET_CPU}-${BUILDDATE}
    COMMAND ${RENAME} <SOURCE_DIR> ${CMAKE_BINARY_DIR}/mpv-${TARGET_CPU}-${BUILDDATE}

    COMMAND mv ${CMAKE_CURRENT_BINARY_DIR}/mpv-debug ${CMAKE_BINARY_DIR}/mpv-debug-${TARGET_CPU}-${BUILDDATE}
    COMMAND ${RENAME} <SOURCE_DIR> ${CMAKE_BINARY_DIR}/mpv-debug-${TARGET_CPU}-${BUILDDATE}

    COMMAND mv ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev ${CMAKE_BINARY_DIR}/mpv-dev-${TARGET_CPU}-${BUILDDATE}
    COMMAND ${RENAME} <SOURCE_DIR> ${CMAKE_BINARY_DIR}/mpv-dev-${TARGET_CPU}-${BUILDDATE}
    COMMENT "Moving mpv package folder"
    LOG 1
)

force_rebuild_git(mpv)
extra_step(mpv)
