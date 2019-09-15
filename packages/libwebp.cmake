ExternalProject_Add(libwebp
    GIT_REPOSITORY https://chromium.googlesource.com/webm/libwebp.git
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND  <SOURCE_DIR>/configure
        --host=
        --prefix=
        --disable-shared
    BUILD_COMMAND 
    INSTALL_COMMAND  install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libwebp)
extra_step(libwebp)
