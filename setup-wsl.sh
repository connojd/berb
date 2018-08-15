#!/bin/bash

sudo apt update
sudo apt install build-essential bison flex python bc

# Download a new cmake
pushd $HOME
wget https://cmake.org/files/v3.12/cmake-3.12.1-Linux-x86_64.tar.gz
tar xzf cmake-3.12.1-Linux-x86_64.tar.gz
echo 'PATH="$HOME/cmake-3.12.1-Linux-x86_64/bin:$PATH"' >> $HOME/.bashrc
popd
