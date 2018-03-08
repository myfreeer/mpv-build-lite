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
ninja crossc x264 gmp libmodplug speex vorbis xvidcore lzo expat

# download pre-built shaderc
wget -nv "https://github.com/myfreeer/build-cache/releases/download/cache/shaderc.7z"
7z x -y shaderc.7z
cp -f ./libshaderc_combined.a ./install/mingw/lib/libshaderc_combined.a
cd ..