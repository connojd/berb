#!/bin/bash

set -e

ln -sf $1/usr/lib/systemd/system/xen-init-dom0.service $1/etc/systemd/system/multi-user.target.wants/xen-init-dom0.service
ln -sf $1/usr/lib/systemd/system/xenconsoled.service $1/etc/systemd/system/multi-user.target.wants/xenconsoled.service
ln -sf $1/usr/lib/systemd/system/xendomains.service $1/etc/systemd/system/multi-user.target.wants/xendomains.service
