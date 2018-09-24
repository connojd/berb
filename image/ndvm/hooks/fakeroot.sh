#!/bin/bash

set -e

mkdir $1/etc/systemd/system/console-getty.service.d

echo "[Service]" > $1/etc/systemd/system/console-getty.service.d/override.conf
echo "ExecStart=" >> $1/etc/systemd/system/console-getty.service.d/override.conf
echo "ExecStart=-/hello" >> $1/etc/systemd/system/console-getty.service.d/override.conf
echo "StandardInput=tty" >> $1/etc/systemd/system/console-getty.service.d/override.conf
echo "StandardOutput=tty" >> $1/etc/systemd/system/console-getty.service.d/override.conf

ln -sf $1/usr/lib/systemd/system/console-getty.service $1/etc/systemd/system/multi-user.target.wants/console-getty.service
