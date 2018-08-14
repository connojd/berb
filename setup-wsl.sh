#!/bin/bash

sudo apt install build-essential bison flex python bc

# Download a new cmake
pushd $HOME
wget https://cmake.org/files/v3.12/cmake-3.12.1-Linux-x86_64.tar.gz
tar xf cmake-3.12.1-Linux-x86_64.tar.gz
export PATH="$HOME/cmake-3.12.1-Linux-x86_64/bin:$PATH"

# Update GCC
sudo add-apt-repository 'deb http://archive.ubuntu.com/ubuntu/ artful main restricted' -u
sudo apt install gcc-7 g++-7
sudo update-alternatives /usr/bin/gcc gcc /usr/bin/gcc-7 100
sudo update-alternatives /usr/bin/g++ g++ /usr/bin/g++-7 100
