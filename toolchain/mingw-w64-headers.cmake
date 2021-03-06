ExternalProject_Add(mingw-w64-headers
    DEPENDS
        mingw-w64
        binutils
    PREFIX mingw-w64-prefix
    SOURCE_DIR mingw-w64-prefix/src
    CONFIGURE_COMMAND <SOURCE_DIR>/mingw-w64/mingw-w64-headers/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --enable-sdk=all
        --enable-secure-api
        --enable-idl
        --with-default-win32-winnt=0x600
    BUILD_COMMAND ""
    INSTALL_COMMAND make install-strip
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)
extra_step(mingw-w64-headers)