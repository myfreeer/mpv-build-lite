ExternalProject_Add(ffmpeg
    DEPENDS
        amf-headers
        avisynth-headers
        nvcodec-headers
        bzip2
        gmp
        lame
        libass
        libbluray
        libpng
        libsoxr
        libbs2b
        libzimg
        libmysofa
        opus
        speex
        x264
        libxml2
        libmfx
        libopenmpt
        dav1d
    GIT_REPOSITORY https://github.com/FFmpeg/FFmpeg.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_SHALLOW 1
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --cross-prefix=${TARGET_ARCH}-
        --prefix=${MINGW_INSTALL_PREFIX}
        --arch=${TARGET_CPU}
        --target-os=mingw32
        --target-exec=wine
        --pkg-config-flags=--static
        --enable-cross-compile
        --enable-runtime-cpudetect
        --enable-gpl
        --enable-version3
        --enable-nonfree
        --enable-postproc
        --enable-avisynth
        --enable-gmp
        --enable-libass
        --enable-libbluray
        --enable-libfreetype
        --enable-libfribidi
        --enable-libopenmpt
        --enable-libmp3lame
        --enable-libopus
        --enable-libsoxr
        --enable-libspeex
        --enable-libbs2b
        --enable-libx264
        --enable-libdav1d
        --enable-libzimg
        --disable-mbedtls
        --enable-schannel
        --enable-libxml2
        --enable-libmysofa
        --disable-libssh
        --disable-libsrt
        --enable-libmfx
        --enable-cuda
        --enable-cuvid
        --enable-nvdec
        --enable-nvenc
        --enable-amf
        --disable-doc
        --disable-ffplay
        --disable-ffprobe
        --disable-encoder=opus
        --disable-encoder=libspeex
        "--extra-libs='-lsecurity -lschannel'" # ffmpeg’s build system is retarded
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(ffmpeg)
cleanup(ffmpeg install)
