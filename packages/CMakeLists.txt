list(APPEND ep
    gmp
    xz
    lzo
    uchardet
    rubberband
    zlib
    bzip2
    libjpeg
    lcms2
    lame
    ogg
    vorbis
    opus
    speex
    libmodplug
    libvpx
    xvidcore
    game-music-emu
    libpng
    x264
    x265
    libdvdcss
    libdvdread
    libdvdnav
    libiconv
    luajit
    openal-soft
    fribidi
    expat
    nettle
    libarchive
    freetype2
    libbluray
    harfbuzz
    libsoxr
    libzimg
    libass
    libressl
    libxml2
    amf
    libmfx
    nvcodec-headers
    ffmpeg
    angle
    mujs
    spirv-headers
    spirv-tools
    glslang
    vulkan
    shaderc
    crossc
    curl
    vapoursynth
    mpv
    flac
    opusfile
    libopusenc
    opus-tools
)
foreach(package IN LISTS ep)
    include(${CMAKE_CURRENT_SOURCE_DIR}/${package}.cmake)
    message(STATUS "Parsing package ${package}")
endforeach()

set(UPDATE_SCRIPT ${CMAKE_SOURCE_DIR}/scripts/update-repo.sh)
add_custom_target(update
    USES_TERMINAL
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    COMMAND chmod 755 ${UPDATE_SCRIPT}
    COMMAND ${EXEC} ${UPDATE_SCRIPT}
    COMMENT "Updating git repo"
)
