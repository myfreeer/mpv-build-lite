#!/bin/bash
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
CPUCOUNT=$(grep -c ^processor /proc/cpuinfo)

git clone --depth 1 https://github.com/skvadrik/re2c.git --config http.sslVerify=false
cd re2c/re2c
./autogen.sh
./configure --prefix=/usr
make -j$CPUCOUNT && make install -j$CPUCOUNT
cd ../..

git clone --depth 1 https://github.com/ninja-build/ninja.git --config http.sslVerify=false
cd ninja
./configure.py --bootstrap
mv ninja.exe /usr/bin
cd ..

wget -nv http://www.colm.net/files/ragel/ragel-6.10.tar.gz
tar -zxvf ragel-6.10.tar.gz
cd ragel-6.10
./configure --prefix=/usr CXXFLAGS="$CXXFLAGS -std=gnu++98" 
make -j$CPUCOUNT && make install -j$CPUCOUNT
cd ..

wget -nv http://downloads.sourceforge.net/project/libjpeg/libjpeg/6b/jpegsr6.zip
unzip jpegsr6
cd jpeg-6b
./configure --prefix=/usr
make -j$CPUCOUNT && make install-lib -j$CPUCOUNT
cd ..

wget -nv --no-check-certificate https://bootstrap.pypa.io/get-pip.py
python2 get-pip.py
pip install rst2pdf