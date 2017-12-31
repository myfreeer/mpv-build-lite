#!/bin/sh

mount  -fo binary,noacl,posix=0,auto "$(pwd -W)" '/build'
cd /build

mkdir -p ./build64
if [ -d './build64/install' ]; then
  rm -rf ./build64/install
fi
cd ./build64
cmake -DTARGET_ARCH=x86_64-w64-mingw32 -G Ninja ..
ninja gcc
ninja libressl vulkan crossc shaderc
cd ..