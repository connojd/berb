#
# Havoc Hypervisor
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

set(HAVOC_ROOT_DIR ${CMAKE_CURRENT_LIST_DIR}/../../..
    CACHE INTERNAL
    "Havoc source root directory"
)

set(HAVOC_CONFIG_DIR ${HAVOC_ROOT_DIR}/config
    CACHE INTERNAL
    "Directory for storing configuration files for various guest images"
)

set(HAVOC_CMAKE_DIR ${HAVOC_ROOT_DIR}/scripts/cmake
    CACHE INTERNAL
    "CMake root directory"
)

set(HAVOC_CMAKE_DEPENDS_DIR ${HAVOC_CMAKE_DIR}/depends
    CACHE INTERNAL
    "CMake depends directory"
)

# ------------------------------------------------------------------------------
# Links
# ------------------------------------------------------------------------------

set(BUILDROOT_URL "https://github.com/connojd/buildroot/archive/master.zip"
    CACHE INTERNAL FORCE
    "Buildroot URL"
)

set(BUILDROOT_URL_MD5 "7a2b095725d6917ff0215c40160e1904"
    CACHE INTERNAL FORCE
    "Buildroot URL MD5 hash"
)

set(BUILDROOT_BUILD_DIR ${DEPENDS_DIR}/buildroot/${USERSPACE_PREFIX}/build
    CACHE INTERNAL
    "The build directory for the guest image"
)

# ------------------------------------------------------------------------------
# Configs
# ------------------------------------------------------------------------------

add_config(
    CONFIG_NAME BUILDROOT_ROOTFS_OVERLAY
    CONFIG_TYPE STRING
    DEFAULT_VAL ""
    DESCRIPTION "Directory to overlay onto the rootfs built by buildroot"
)

add_config(
    CONFIG_NAME BUILDROOT_PREBUILD_HOOK
    CONFIG_TYPE STRING
    DEFAULT_VAL ""
    DESCRIPTION "Hook for pre-build customization of the image"
)

add_config(
    CONFIG_NAME BUILDROOT_FAKEROOT_HOOK
    CONFIG_TYPE STRING
    DEFAULT_VAL ""
    DESCRIPTION "Hook for post-build and pre-archive customization of the image"
)

add_config(
    CONFIG_NAME BUILDROOT_POSTARCHIVE_HOOK
    CONFIG_TYPE STRING
    DEFAULT_VAL ""
    DESCRIPTION "Hook for post-archive customization of the image"
)

add_config(
    CONFIG_NAME BUILDROOT_CONFIG_IN
    CONFIG_TYPE FILEPATH
    DEFAULT_VAL ${HAVOC_CONFIG_DIR}/xenstore/buildroot.config.in
    DESCRIPTION "The .config file used by buildroot to build the guest image"
)

add_config(
    CONFIG_NAME LINUX_CONFIG_IN
    CONFIG_TYPE FILEPATH
    DEFAULT_VAL ${HAVOC_CONFIG_DIR}/xenstore/linux.config.in
    DESCRIPTION "The .config file for the guest kernel"
)
