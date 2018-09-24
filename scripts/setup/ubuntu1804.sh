#!/bin/bash

sudo apt-get install -y make cmake gcc g++ python autoconf bison flex \
    texinfo help2man gawk libtool libtool-bin libncurses5-dev libelf-dev \
    libssl-dev

cd $HOME
mkdir -p bareflank
cd bareflank

git clone https://github.com/bareflank/hypervisor.git
git clone -b crosstool-ng https://github.com/connojd/havoc.git erb

mkdir build-tools
cd build-tools
cmake ../hypervisor -DEXTENSION=../erb -DBUILD_TOOLS_ONLY=ON
