ExternalProject_Add(expat
    URL "https://github.com/libexpat/libexpat/releases/download/R_2_2_9/expat-2.2.9.tar.xz"
    URL_HASH SHA256=1ea6965b15c2106b6bbe883397271c80dfa0331cdf821b2c319591b55eadc0a4
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

extra_step(expat)
