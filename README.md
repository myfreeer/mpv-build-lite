# CMake-based MinGW-w64 Cross Toolchain

This thing’s primary use is to build Windows binaries of mpv.

## Build status

[![Build status](https://ci.appveyor.com/api/projects/status/36cotsp4p1klgvay?svg=true)](https://ci.appveyor.com/project/myfreeer/mpv-build-lite)

Artifacts built by appveyor:
* 64-bit static mpv binary with pdf docs: [mpv.7z](https://ci.appveyor.com/api/projects/myfreeer/mpv-build-lite/artifacts/mpv.7z?branch=master)
* 64-bit shared libmpv dll and headers: [mpv-dev.7z](https://ci.appveyor.com/api/projects/myfreeer/mpv-build-lite/artifacts/mpv-dev.7z?branch=master)
* 64-bit debugging symbol for mpv: [mpv-debug.7z](https://ci.appveyor.com/api/projects/myfreeer/mpv-build-lite/artifacts/mpv-debug.7z?branch=master)
* 64-bit pre-build toolchain: [toolchain.7z](https://ci.appveyor.com/api/projects/myfreeer/mpv-build-lite/artifacts/toolchain.7z?branch=toolchain)

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
    - libpng
    - libsoxr
    - libzimg
    - libdvdread
    - libdvdnav
    - libdvdcss
    - libbluray
    - libass
    - lcms2
    - lame
    - harfbuzz
    - game-music-emu
    - freetype2
    - flac
    - opus-tools
    - mujs
    - libarchive
    - libjpeg
    - shaderc (with spirv-headers, spirv-tools, glslang)
    - vulkan
    - crossc
    - fribidi
    - libressl
    - nettle
    - curl
    - libxml2
    - amf
    - libmfx

- Zip
    - expat (2.2.5)
    - bzip (1.0.6)
    - zlib (1.2.11)
    - xvidcore (1.3.5)
    - vorbis (1.3.5)
    - speex (1.2.0)
    - ogg (1.3.3)
    - lzo (2.10)
    - libmodplug (0.8.9.0)
    - libiconv (1.15)
    - gmp (6.1.2)
    - vapoursynth (R40)


## Setup Build Environment
### Manjaro / Arch Linux

These packages need to be installed first before compiling mpv:

    pacman -S git gyp mercurial ninja cmake ragel yasm nasm asciidoc enca gperf unzip p7zip gcc-multilib python2-pip python-docutils python2-rst2pdf python2-lxml python2-pillow

### Ubuntu Linux / WSL (Windows 10)

    apt-get install build-essential checkinstall bison flex gettext git mercurial subversion ninja-build gyp cmake yasm nasm automake pkg-config libtool libtool-bin gcc-multilib g++-multilib libgmp-dev libmpfr-dev libmpc-dev libgcrypt-dev gperf ragel texinfo autopoint re2c asciidoc python-docutils rst2pdf docbook2x unzip p7zip-full

**Note:**

* Works for Ubuntu 15.10 and later. Ubuntu 14.04 used outdated packages which make compilation failed. For WSL, upgrade with [this](https://github.com/Microsoft/BashOnWindows/issues/482#issuecomment-230551101) [step](https://github.com/Microsoft/BashOnWindows/issues/482#issuecomment-234695431)
* Use [apt-fast](https://github.com/ilikenwf/apt-fast) if apt-get is too slow.
* It is advised to use bash over dash. Set `sudo ln -sf /bin/bash /bin/sh`. Revert back by `sudo ln -sf /bin/dash /bin/sh`.
* For WSL, some packages will fail when compiling to 32bit. This is because WSL [doesn't support multilib ABI](https://github.com/Microsoft/BashOnWindows/issues/711/) yet.

### Cygwin

Download Cygwin installer and run:

    setup-x86_64.exe -R "C:\cygwin64" -q --packages="bash,binutils,bzip2,cygwin,gcc-core,gcc-g++,cygwin32-gcc-core,cygwin32-gcc-g++,gzip,m4,pkg-config,make,unzip,zip,diffutils,wget,git,patch,cmake,gperf,yasm,nasm,enca,asciidoc,bison,flex,gettext-devel,mercurial,python-devel,python-docutils,docbook2X,texinfo,libmpfr-devel,libgmp-devel,libmpc-devel,libtool,autoconf2.5,automake,automake1.9,libxml2-devel,libxslt-devel"

Additionally, some packages, `re2c`, `ninja`, `ragel`, `gyp`, `rst2pdf` need to be [installed manually](https://gist.github.com/shinchiro/705b0afcc7b6c0accffba1bedb067abf).

### MSYS2

Install MSYS2 and run it via `MSYS2 MSYS` shortcut.
Don't use `MSYS2 MinGW 32-bit` or `MSYS2 MinGW 64-bit` shortcuts, that's important!

These packages need to be installed first before compiling mpv:

    pacman -Sy base-devel cmake gcc yasm nasm git mercurial subversion gyp tar gmp-devel mpc-devel mpfr-devel python zlib-devel unzip zip p7zip --needed

Don't install anything from the `mingw32` and `mingw64` repositories,
it's better to completely disable them in `/etc/pacman.conf` just to be safe.

Additionally, some packages, `re2c`, `ninja`, `ragel`, `libjpeg`, `rst2pdf` need to be [installed manually](https://gist.github.com/shinchiro/705b0afcc7b6c0accffba1bedb067abf)
or use `build-deps.sh` to automatically download, build, and install them.

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
    ninja vulkan crossc shaderc gmp libmodplug speex vorbis xvidcore lzo expat

After it done, you're ready to build mpv and all its dependencies:

    ninja mpv

For MSYS2, you can just use `build-mpv.sh` for a 64-bit build, ignoring steps above.

## Building Software (Second Time)

To build mpv for a second time, clean all packages' stamp files:

    ninja clean

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
