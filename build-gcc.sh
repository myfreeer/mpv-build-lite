#!/bin/sh

mount  -fo binary,noacl,posix=0,auto "$(pwd -W)" '/build'
cd /build

# toolchain building and uploading
# Thanks to https://github.com/mpv-android/mpv-android
upload_to_github() {
    local file="$1"
    local release_id=9992583
    local repo="myfreeer/build-cache"
    local Content_Type=application/octet-stream
    if [ -n "$GITHUB_TOKEN" ]; then
        echo "Uploading ${file}..."
        curl -H "Authorization: token $GITHUB_TOKEN" -H "Content-Type: ${Content_Type}" --data-binary @$file \
            "https://uploads.github.com/repos/${repo}/releases/${release_id}/assets?name=${file}"
    fi
}

build_toolchain() {
    echo Building toolchain gcc-$gcc_version binutils-$binutils_version...
    ninja gcc
    if [ -n "$GITHUB_TOKEN" ]; then
        echo Packing toolchain...
        7z a -mx9 "${toolchain_package}" install/*
        echo Uploading toolchain to cache...
        upload_to_github "${toolchain_package}"
    fi
}

# init toolchain versions
gcc_version="$(cat toolchain/gcc-base.cmake | grep -ioP 'gcc-\d+\.\d+\.\d+' | sort -u | grep -ioP '[\d\.]+')"
binutils_version="$(cat toolchain/binutils.cmake | grep -ioP 'binutils-(\d+\.)+\d+' | sort -u | grep -ioP '[\d\.]+')"
# init toolchain
toolchain_package="msys2-gcc-${gcc_version}_binutils-${binutils_version}.7z"

# msys2: update for newest nasm and p7zip
pacman -Sy nasm p7zip --noconfirm --needed --noprogressbar --ask 20

mkdir -p ./build64
if [ -d './build64/install' ]; then
  rm -rf ./build64/install
fi
cd ./build64
cmake -DTARGET_ARCH=x86_64-w64-mingw32 -G Ninja ..
wget -nv "https://github.com/myfreeer/build-cache/releases/download/cache/${toolchain_package}" && \
     7z x "${toolchain_package}" && rm -f "${toolchain_package}" || build_toolchain
ninja x264 libmodplug speex vorbis

# download pre-built shaderc
wget -nv "https://github.com/myfreeer/build-cache/releases/download/cache/shaderc_and_crossc.7z"
7z x -y shaderc_and_crossc.7z
sed -i 's/mpv-build-lite/build/g' install/mingw/lib/pkgconfig/crossc.pc

# download pre-built versioned packages
gmp_version="$(grep -ioP 'gmp-((\d+\.)+\d+)' ../packages/gmp.cmake | cut -d'-' -f2)"
xvidcore_version="$(grep -ioP 'xvidcore-((\d+\.)+\d+)' ../packages/xvidcore.cmake | cut -d'-' -f2)"
libiconv_version="$(grep -ioP 'libiconv-((\d+\.)+\d+)' ../packages/libiconv.cmake | cut -d'-' -f2)"
expat_version="$(grep -ioP 'expat-((\d+\.)+\d+)' ../packages/expat.cmake | cut -d'-' -f2)"
lzo_version="$(grep -ioP 'lzo-((\d+\.)+\d+)' ../packages/lzo.cmake | cut -d'-' -f2)"
libiconv_package="libiconv-${libiconv_version}.7z"
xvidcore_package="xvidcore-${xvidcore_version}.7z"
gmp_package="gmp-${gmp_version}.7z"
expat_package="expat-${expat_version}.7z"
lzo_package="lzo-${lzo_version}.7z"
wget -nv "https://github.com/myfreeer/build-cache/releases/download/cache/${libiconv_package}"
wget -nv "https://github.com/myfreeer/build-cache/releases/download/cache/${xvidcore_package}"
wget -nv "https://github.com/myfreeer/build-cache/releases/download/cache/${gmp_package}"
wget -nv "https://github.com/myfreeer/build-cache/releases/download/cache/${expat_package}"
wget -nv "https://github.com/myfreeer/build-cache/releases/download/cache/${lzo_package}"
7z x -y "${libiconv_package}"
7z x -y "${xvidcore_package}"
7z x -y "${gmp_package}"
7z x -y "${expat_package}"
7z x -y "${lzo_package}"
cd ..