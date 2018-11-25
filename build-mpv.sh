#!/bin/bash

# temporary downgrade subversion to 1.10.3-1
# svn: E175003: The server at 'https://github.com/GPUOpen-LibrariesAndSDKs/AMF/trunk/amf/public/include' does not support the HTTP/DAV protocol
# https://mail-archives.apache.org/mod_mbox/subversion-users/201811.mbox/%3C16862E55-81D9-4FA7-B6D0-ABCCDD4D3E1D@obsigna.com%3E
# https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=232945

wget -nv http://repo.msys2.org/msys/x86_64/subversion-1.10.3-1-x86_64.pkg.tar.xz
pacman -U --noconfirm subversion-1.10.3-1-x86_64.pkg.tar.xz

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
wget -nv "https://github.com/myfreeer/build-cache/releases/download/cache/${libiconv_package}" && 7z x -y "${libiconv_package}"
wget -nv "https://github.com/myfreeer/build-cache/releases/download/cache/${xvidcore_package}" && 7z x -y "${xvidcore_package}"
wget -nv "https://github.com/myfreeer/build-cache/releases/download/cache/${gmp_package}" && 7z x -y "${gmp_package}"
wget -nv "https://github.com/myfreeer/build-cache/releases/download/cache/${expat_package}" && 7z x -y "${expat_package}"
wget -nv "https://github.com/myfreeer/build-cache/releases/download/cache/${lzo_package}" && 7z x -y "${lzo_package}"

# build mpv
ninja mpv
cd ..