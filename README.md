# CMake-based MinGW-w64 Cross Toolchain

This thing’s primary use is to build Windows binaries of mpv.

## Build status

[![Build status](https://ci.appveyor.com/api/projects/status/36cotsp4p1klgvay?svg=true)](https://ci.appveyor.com/project/myfreeer/mpv-build-lite)

Artifacts built by appveyor:
* 64-bit static mpv binary with pdf docs: [mpv.7z](https://ci.appveyor.com/api/projects/myfreeer/mpv-build-lite/artifacts/mpv.7z?branch=master)
* 64-bit shared libmpv dll and headers: [mpv-dev.7z](https://ci.appveyor.com/api/projects/myfreeer/mpv-build-lite/artifacts/mpv-dev.7z?branch=master)
* 64-bit debugging symbol for mpv: [mpv-debug.7z](https://ci.appveyor.com/api/projects/myfreeer/mpv-build-lite/artifacts/mpv-debug.7z?branch=master)

## Prerequisites

 -  You should also install Ninja and use CMake’s Ninja build file generator.
    It’s not only much faster than GNU Make, but also far less error-prone,
    which is important for this project because CMake’s ExternalProject module
    tends to generate makefiles which confuse GNU Make’s jobserver thingy.

 -  As a build environment, any modern Linux distribution *should* work.

-   Compiling on Cygwin / MSYS2 is supported, but it tends to be slower
    than compiling on Linux.


## Information about packages

- Git/Hg
    - ANGLE
    - FFmpeg
    - xz
    - x264
    - x265 (multilib)
    - uchardet
    - rubberband
    - opus
    - openal-soft
    - mpv
    - luajit
    - libvpx
    - libwebp
    - libpng
    - libsoxr
    - libzimg
    - libdvdread
    - libdvdnav
    - libdvdcss
    - libbluray
    - libass
    - libmysofa
    - lcms2
    - lame
    - harfbuzz
    - freetype2
    - flac
    - opus-tools
    - mujs
    - libarchive
    - libjpeg
    - shaderc (with spirv-headers, spirv-tools, glslang)
    - vulkan
    - spirv-cross
    - fribidi
    - libressl
    - nettle
    - curl
    - libxml2
    - amf
    - libmfx
    - libmodplug
    - vapoursynth
    - avisynth-headers
    - nvcodec-headers
    - dav1d
    - libplacebo

- Zip
    - expat (2.2.9)
    - bzip (1.0.8)
    - zlib (1.2.11)
    - xvidcore (1.3.7)
    - vorbis (1.3.6)
    - speex (1.2.0)
    - ogg (1.3.4)
    - lzo (2.10)
    - libiconv (1.16)
    - gmp (6.1.2)
    - game-music-emu (0.6.2)


## Setup Build Environment
### Manjaro / Arch Linux

These packages need to be installed first before compiling mpv:

    pacman -S git gyp mercurial subversion ninja cmake meson ragel yasm nasm asciidoc enca gperf unzip p7zip gcc-multilib clang python-pip curl

    pip3 install rst2pdf mako
 

### Ubuntu Linux / WSL (Windows 10)

    apt-get install build-essential checkinstall bison flex gettext git mercurial subversion ninja-build gyp cmake yasm nasm automake pkg-config libtool libtool-bin gcc-multilib g++-multilib clang libgmp-dev libmpfr-dev libmpc-dev libgcrypt-dev gperf ragel texinfo autopoint re2c asciidoc python3-pip docbook2x unzip p7zip-full curl

    pip3 install rst2pdf meson mako

**Note:**

* Use [apt-fast](https://github.com/ilikenwf/apt-fast) if apt-get is too slow.
* It is advised to use bash over dash. Set `sudo ln -sf /bin/bash /bin/sh`. Revert back by `sudo ln -sf /bin/dash /bin/sh`.
* On WSL platform, compiling 32bit require qemu. Refer to [this](https://github.com/Microsoft/WSL/issues/2468#issuecomment-374904520).
* To update package installed by pip, run `pip3 install <package> --upgrade`.

### Cygwin

Download Cygwin installer and run:

    setup-x86_64.exe -R "C:\cygwin64" -q --packages="bash,binutils,bzip2,cygwin,gcc-core,gcc-g++,cygwin32-gcc-core,cygwin32-gcc-g++,gzip,m4,pkg-config,make,unzip,zip,diffutils,wget,git,patch,cmake,gperf,yasm,nasm,enca,asciidoc,bison,flex,gettext-devel,mercurial,python-devel,python-docutils,docbook2X,texinfo,libmpfr-devel,libgmp-devel,libmpc-devel,libtool,autoconf2.5,automake,automake1.9,libxml2-devel,libxslt-devel"

Additionally, some packages, `re2c`, `ninja`, `ragel`, `gyp`, `rst2pdf` need to be [installed manually](https://gist.github.com/shinchiro/705b0afcc7b6c0accffba1bedb067abf).

### MSYS2

Building on MSYS2 is currently broken since meson [won't work](https://github.com/mesonbuild/meson/blob/46f3b8f75354af8e87ee267a94e7ae4602789e53/docs/markdown/Getting-meson.md#msys2-python3-quirks) on MSYS2, which is now required to build dav1d decoder.

## Building Software (First Time)

To set up the build environment, create a directory to store build files in:

    mkdir build64
    cd build64

Once you’ve changed into that directory, run CMake, e.g.

    cmake -DTARGET_ARCH=x86_64-w64-mingw32 -G Ninja ..

or for 32bit:

    cmake -DTARGET_ARCH=i686-w64-mingw32 -G Ninja ..

First, you need to build toolchain. By default, it will be installed in `install` folder.

    ninja gcc
    ninja x264 crossc shaderc gmp libmodplug speex vorbis xvidcore lzo expat

After it done, you're ready to build mpv and all its dependencies:

    ninja mpv

## Building Software (Second Time)

To build mpv for a second time:

    ninja update

After that, build mpv as usual:

    ninja vulkan crossc shaderc gmp libmodplug speex vorbis xvidcore lzo expat
    ninja mpv

This will also build all packages that `mpv` depends on.

## Available Commands

* **ninja package** -> compile a package

* **ninja clean** -> remove all stamp files in all packages.

* **ninja package-fullclean** -> Remove all stamp files of a package.

* **ninja package-liteclean** -> Remove build, clean stamp files only. This will skip re-configure in next running `ninja package` (after first time compile). Updating repo or patching need to do manually. Ideally, all `DEPENDS` target in `package.cmake` should be temporarily commented or deleted. Might be useful in some case.

* **ninja update** -> Update all git repos. When a package pulling new changes, all of its stamp files will be deleted and will be force rebuild. If there is not changes, it will not remove the stamp files and not rebuild occur. Use this instead of `ninja clean` if you don't want rebuild everything in next run.

`package` is package's name found in `packages` folder.
