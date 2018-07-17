ExternalProject_Add(libressl
    URL "https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.7.4.tar.gz"
    URL_HASH SHA256=1e3a9fada06c1c060011470ad0ff960de28f9a0515277d7336f7e09362517da6
    PATCH_COMMAND ${EXEC} sed -i '/SUBDIRS = crypto ssl tls include apps tests man/ c\\SUBDIRS = crypto ssl tls include\\' Makefile.am Makefile.in
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

extra_step(libressl)
