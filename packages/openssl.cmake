if(${TARGET_CPU} MATCHES "i686")
    set(mingw "mingw")
else()
    set(mingw "mingw64")
    set(ec "enable-ec_nistp_64_gcc_128")
endif()
ExternalProject_Add(openssl
    DEPENDS
        zlib
        zstd
        brotli
    GIT_REPOSITORY https://github.com/openssl/openssl.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    GIT_SUBMODULES ""
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 <SOURCE_DIR>/Configure
        --cross-compile-prefix=${TARGET_ARCH}-
        --prefix=${MINGW_INSTALL_PREFIX}
        --libdir=lib
        --release
        no-autoload-config
        no-ssl3-method
        enable-brotli
        no-whirlpool
        no-filenames
        no-camellia
        enable-zstd
        no-capieng
        no-shared
        no-rmd160
        no-module
        no-legacy
        no-tests
        ${mingw}
        threads
        no-docs
        no-apps
        no-quic
        no-ocsp
        no-ssl3
        no-cmac
        no-mdc2
        no-idea
        no-cast
        no-srtp
        no-seed
        no-aria
        no-err
        no-dso
        no-dsa
        no-srp
        no-rc2
        no-rc4
        no-sm2
        no-sm3
        no-sm4
        no-md4
        no-cms
        no-cmp
        no-dh
        no-bf
        zlib
        ${ec}
    BUILD_COMMAND ${MAKE} build_sw
    INSTALL_COMMAND ${MAKE} install_sw
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(openssl)
cleanup(openssl install)
