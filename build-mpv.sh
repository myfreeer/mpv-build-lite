#!/bin/bash

# msys2-only workaround for x264
mkdir nasm
cd nasm
wget http://repo.msys2.org/mingw/x86_64/mingw-w64-x86_64-nasm-2.13.01-1-any.pkg.tar.xz
tar -Jxvf mingw-w64-x86_64-nasm-2.13.01-1-any.pkg.tar.xz
cp ./mingw64/bin/* /bin
cd ..

mkdir -p ./build64
cd ./build64
cmake -DTARGET_ARCH=x86_64-w64-mingw32 -G Ninja ..
ninja mpv
cd ..