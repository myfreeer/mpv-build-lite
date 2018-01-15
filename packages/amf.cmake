ExternalProject_Add(amf
    DOWNLOAD_COMMAND svn export --force https://github.com/GPUOpen-LibrariesAndSDKs/AMF/trunk/amf/public/include AMF
    DOWNLOAD_DIR ${MINGW_INSTALL_PREFIX}/include
    DOWNLOAD_NO_PROGRESS 1
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

extra_step(amf)
