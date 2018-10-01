#!/bin/bash

mount  -fo binary,noacl,posix=0,auto "$(pwd -W)" '/build'
cd /build

# msys2: update for newest nasm and p7zip
pacman -Sy nasm p7zip --noconfirm --needed --noprogressbar --ask 20

mkdir -p ./build64
cd ./build64
echo 'int main(){return 0;}' > gcctest.c
install/bin/x86_64-w64-mingw32-gcc.exe gcctest.c || {
wget -c -nv -Otoolchain.7z https://ci.appveyor.com/api/projects/myfreeer/mpv-build-lite/artifacts/toolchain.7z?branch=toolchain
mkdir -p install
cd install
7z x -y ../toolchain.7z
cd ..
}
cmake -DTARGET_ARCH=x86_64-w64-mingw32 -G Ninja ..
ninja mpv
cd ..