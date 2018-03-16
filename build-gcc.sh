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
ninja x264 gmp libmodplug speex vorbis xvidcore lzo expat

# download pre-built shaderc
wget -nv "https://github.com/myfreeer/build-cache/releases/download/cache/shaderc_and_crossc.7z"
7z x -y shaderc_and_crossc.7z
sed -i 's/mpv-build-lite/build/g' install/mingw/lib/pkgconfig/crossc.pc
cd ..