#
# Bareflank Hypervisor
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
# Source tree
# ------------------------------------------------------------------------------

set(HAVOC_SRC_ROOT_DIR ${CMAKE_CURRENT_LIST_DIR}/../../..
    CACHE INTERNAL
    "Havoc source root directory"
)

set(HAVOC_SRC_CONFIG_DIR ${HAVOC_SRC_ROOT_DIR}/config
    CACHE INTERNAL
    "Directory for storing build config.in files for guests"
)

set(HAVOC_SRC_CMAKE_DIR ${HAVOC_SRC_ROOT_DIR}/scripts/cmake
    CACHE INTERNAL
    "CMake root directory"
)

set(HAVOC_SRC_CMAKE_DEPENDS_DIR ${HAVOC_SRC_CMAKE_DIR}/depends
    CACHE INTERNAL
    "CMake depends directory"
)

# ------------------------------------------------------------------------------
# Links
# ------------------------------------------------------------------------------

set(LINUX_URL "https://github.com/torvalds/linux/archive/v4.18.tar.gz"
    CACHE INTERNAL FORCE
    "Linux URL"
)

set(LINUX_URL_MD5 "e7d9bb36da7aee08eb1f07a54a2754bd"
    CACHE INTERNAL FORCE
    "Linux URL MD5 hash"
)

# ------------------------------------------------------------------------------
# Linux guest configs
# ------------------------------------------------------------------------------

add_config(
    CONFIG_NAME LINUX_BUILD_DIR
    CONFIG_TYPE STRING
    DEFAULT_VAL ${DEPENDS_DIR}/linux/${USERSPACE_PREFIX}/build
    DESCRIPTION "The build directory for the guest kernel"
)

add_config(
    CONFIG_NAME LINUX_CONFIG_IN
    CONFIG_TYPE STRING
    DEFAULT_VAL ${HAVOC_SRC_CONFIG_DIR}/linux/tiny.config.in
    DESCRIPTION "The .config file for the guest kernel"
)

add_config(
    CONFIG_NAME LINUX_INITRAMFS_IN
    CONFIG_TYPE STRING
    DEFAULT_VAL ${HAVOC_SRC_CONFIG_DIR}/initramfs/tiny.config.in
    DESCRIPTION "The input to the linux tree's usr/gen_init_cpio binary"
)

add_config(
    CONFIG_NAME LINUX_INITRAMFS_ROOT
    CONFIG_TYPE STRING
    DEFAULT_VAL ${HAVOC_SRC_ROOT_DIR}/initramfs/tiny/
    DESCRIPTION "The root of the initramfs to build into the kernel"
)

add_config(
    CONFIG_NAME LINUX_INITRAMFS_IMAGE
    CONFIG_TYPE STRING
    DEFAULT_VAL ""
    DESCRIPTION "Path to an existing initramfs image fit for the guest kernel"
)
