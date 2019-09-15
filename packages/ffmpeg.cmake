ExternalProject_Add(ffmpeg
    DEPENDS
        amf
        bzip2
        game-music-emu
        lame
        libass
        libbluray
        libpng
        libsoxr
        libwebp
        libzimg
        libmysofa
        libmodplug
        libxml2
        libmfx
        opus
        speex
        vorbis
        nvcodec-headers
        x264
        dav1d
    GIT_REPOSITORY https://github.com/FFmpeg/FFmpeg.git
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
        --enable-avresample
        --enable-postproc
        --enable-avisynth
        --enable-gmp
        --enable-libass
        --enable-libbluray
        --enable-libfreetype
        --enable-libfribidi
        --enable-libgme
        --enable-libmodplug
        --enable-libmp3lame
        --enable-libopus
        --enable-libsoxr
        --enable-libspeex
        --enable-libvorbis
        --enable-libwebp
        --enable-libx264
#       --enable-libaom
        --enable-libxvid
        --enable-libzimg
        --enable-schannel
        --enable-libxml2
        --enable-cuda
        --enable-cuvid
        --enable-nvdec
        --enable-nvenc
        --enable-libmysofa
        --enable-amf
        --enable-libmfx
        --enable-libdav1d
        --disable-debug
        --disable-doc
        --disable-programs
        "--extra-libs='-lsecurity -lschannel'" # ffmpeg’s build system is retarded
        "--extra-cflags=-DMODPLUG_STATIC"
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(ffmpeg)
extra_step(ffmpeg)
