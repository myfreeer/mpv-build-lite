ExternalProject_Add(libressl
    URL "https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.8.1.tar.gz"
    URL_HASH SHA256=334bf7050f1db4087feebb30571ec13d9fa975bf05d6003ce3ab6d7d2452cf42
    CONFIGURE_COMMAND ${EXEC} cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        -G Ninja
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DLIBRESSL_APPS=OFF
        -DLIBRESSL_TESTS=OFF
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

extra_step(libressl)
