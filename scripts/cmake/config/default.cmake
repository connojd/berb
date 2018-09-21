#
# ERB
# Copyright (C) 2018 Assured Information Security, Inc.
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA

# ------------------------------------------------------------------------------
# The cross-compiler to build
# ------------------------------------------------------------------------------

add_config(
    CONFIG_NAME TUPLE
    CONFIG_TYPE STRING
    DEFAULT_VAL "x86_64-unknown-linux-gnu"
    DESCRIPTION "The tuple of the cross-compiler to build"
    OPTIONS "x86_64-unknown-linux-gnu"
)

# ------------------------------------------------------------------------------
# The guest image to build
# ------------------------------------------------------------------------------

add_config(
    CONFIG_NAME IMAGE
    CONFIG_TYPE STRING
    DEFAULT_VAL "tiny"
    DESCRIPTION "The guest image to build"
    OPTIONS "tiny"
    OPTIONS "xenstore"
)

# ------------------------------------------------------------------------------
# Image variables
# ------------------------------------------------------------------------------

set(CT_CONFIG_IN ${ERB_TOOLS_DIR}/${TUPLE}/crosstool.config.in)
set(BR2_CONFIG_IN ${ERB_IMAGE_DIR}/${IMAGE}/buildroot.config.in)
set(LINUX_CONFIG_IN ${ERB_IMAGE_DIR}/${IMAGE}/linux.config.in)

# ------------------------------------------------------------------------------
# Fakeroot hooks
# ------------------------------------------------------------------------------

set(
    BR2_ROOTFS_POST_FAKEROOT_HOOKS
    $<IF:$<STREQUAL:"${IMAGE}","xenstore">,"${ERB_IMAGE_DIR}/${IMAGE}/hooks/fakeroot/init-systemd.sh","">
)
