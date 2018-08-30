#!/bin/bash
set -e

sudo ln -sf /usr/bin/python2 /usr/bin/python
sudo pacman -S yajl iasl python2-yaml --needed --noconfirm

./configure --disable-rombios --disable-docs --disable-stubdom --prefix=/usr
make dist-xen -j$(nproc)
make dist-tools -j$(nproc)
