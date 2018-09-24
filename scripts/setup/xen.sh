#!/bin/bash

case $(cat /etc/os-release | grep 'ID_LIKE=' | cut -d'=' -f 2) in
arch*|Arch*)
    sudo pacman -S python2 --needed --noconfirm
    sudo ln -fs /usr/bin/python2 /usr/bin/python
    ;;
debian)
    sudo apt-get build-dep xen
    ;;
esac
