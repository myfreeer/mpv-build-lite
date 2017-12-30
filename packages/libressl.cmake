ExternalProject_Add(libressl
    URL "http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.6.4.tar.gz"
    URL_HASH SHA256=638a20c2f9e99ee283a841cd787ab4d846d1880e180c4e96904fc327d419d11f
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
