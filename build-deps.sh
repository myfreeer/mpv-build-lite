#!/bin/bash
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
CPUCOUNT=$(grep -c ^processor /proc/cpuinfo)

pacman -Sy re2c --noconfirm --needed --noprogressbar --ask 20

git clone --depth 1 https://github.com/ninja-build/ninja.git --config http.sslVerify=false
cd ninja
./configure.py --bootstrap
mv ninja.exe /usr/bin
cd ..

wget -nv https://www.colm.net/files/ragel/ragel-6.10.tar.gz
tar -zxf ragel-6.10.tar.gz
cd ragel-6.10
./configure --enable-silent-rules --disable-dependency-tracking --prefix=/usr CXXFLAGS="$CXXFLAGS -std=gnu++98" 
make -j$CPUCOUNT && make install -j$CPUCOUNT
cd ..

wget -nv http://www.ijg.org/files/jpegsr6b.zip
unzip -q jpegsr6b.zip
cd jpeg-6b
./configure --prefix=/usr
make -j$CPUCOUNT && make install-lib -j$CPUCOUNT
cd ..

wget -nv --no-check-certificate https://bootstrap.pypa.io/get-pip.py
python2 get-pip.py
pip install rst2pdf