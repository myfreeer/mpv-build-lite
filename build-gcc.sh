#!/bin/sh

mount  -fo binary,noacl,posix=0,auto "$(pwd -W)" '/build'
cd /build

# msys2: update for newest nasm and p7zip
pacman -Sy nasm p7zip --noconfirm --needed --noprogressbar --ask 20

mkdir -p ./build64
if [ -d './build64/install' ]; then
  rm -rf ./build64/install
fi
cd ./build64
cmake -DTARGET_ARCH=x86_64-w64-mingw32 -G Ninja ..
ninja gcc
ninja x264 libmodplug speex vorbis lzo expat

# download pre-built shaderc
wget -nv "https://github.com/myfreeer/build-cache/releases/download/cache/shaderc_and_crossc.7z"
7z x -y shaderc_and_crossc.7z
sed -i 's/mpv-build-lite/build/g' install/mingw/lib/pkgconfig/crossc.pc

# download pre-built versioned packages
gmp_version="$(grep -ioP 'gmp-((\d+\.)+\d+)' ../packages/gmp.cmake | cut -d'-' -f2)"
xvidcore_version="$(grep -ioP 'xvidcore-((\d+\.)+\d+)' ../packages/xvidcore.cmake | cut -d'-' -f2)"
libiconv_version="$(grep -ioP 'libiconv-((\d+\.)+\d+)' ../packages/libiconv.cmake | cut -d'-' -f2)"
libiconv_package="libiconv-${libiconv_version}.7z"
xvidcore_package="xvidcore-${xvidcore_version}.7z"
gmp_package="gmp-${gmp_version}.7z"
wget -nv "https://github.com/myfreeer/build-cache/releases/download/cache/${libiconv_package}"
wget -nv "https://github.com/myfreeer/build-cache/releases/download/cache/${xvidcore_package}"
wget -nv "https://github.com/myfreeer/build-cache/releases/download/cache/${gmp_package}"
7z x -y "${libiconv_package}"
7z x -y "${xvidcore_package}"
7z x -y "${gmp_package}"
sed -i 's/mpv-build-lite/build/g' install/mingw/lib/*.la
cd ..