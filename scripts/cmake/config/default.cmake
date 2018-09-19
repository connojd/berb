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

set(HAVOC_SCRIPTS_DIR ${HAVOC_ROOT_DIR}/scripts
    CACHE INTERNAL
    "Directory for storing script files (cmake, bash, etc)"
)

set(HAVOC_CMAKE_DIR ${HAVOC_SCRIPTS_DIR}/cmake
    CACHE INTERNAL
    "CMake root directory"
)

set(HAVOC_CMAKE_DEPENDS_DIR ${HAVOC_CMAKE_DIR}/depends
    CACHE INTERNAL
    "CMake depends directory"
)

# ------------------------------------------------------------------------------
# Crosstool variables
# ------------------------------------------------------------------------------

set(CT_URL "https://github.com/connojd/crosstool-ng/archive/master.zip"
    CACHE INTERNAL FORCE
    "Crosstool-ng URL"
)

set(CT_URL_MD5 "0e487e9da3013cbe20d07891c33e10ff"
    CACHE INTERNAL FORCE
    "Crosstool-ng URL MD5 hash"
)

set(CT_BUILD_DIR ${DEPENDS_DIR}/crosstool-ng/${USERSPACE_PREFIX}/build
    CACHE INTERNAL
    "The build dir for the toolchain targeting the guest image"
)

#
# Note that crosstool-ng provides many preconfigured toolchains.
# You can run ./ct-ng list-samples to see them all. As we use/test
# more, we can pass them to the OPTIONS argument here.
#
# These configs are all the information that buildroot needs about
# the external toolchain.
#
add_config(
    CONFIG_NAME CT_TARGET
    CONFIG_TYPE STRING
    DEFAULT_VAL "x86_64-unknown-linux-gnu"
    DESCRIPTION "Target tuple of the toolchain"
)

add_config(
    CONFIG_NAME CT_TARGET_VENDOR
    CONFIG_TYPE STRING
    DEFAULT_VAL "erb"
    DESCRIPTION "The vendor of the toolchain"
)

add_config(
    CONFIG_NAME CT_PREFIX_DIR
    CONFIG_TYPE STRING
    DEFAULT_VAL "${CT_BUILD_DIR}/x-tools/${CT_TARGET}"
    DESCRIPTION "Directory of toolchain prefix"
)

# ------------------------------------------------------------------------------
# Buildroot
# ------------------------------------------------------------------------------

set(BUILDROOT_URL "https://buildroot.org/downloads/buildroot-2018.08.tar.gz"
    CACHE INTERNAL FORCE
    "Buildroot URL"
)

set(BUILDROOT_URL_MD5 "8cc486858fc7812388dd82c27c3a2dcc"
    CACHE INTERNAL FORCE
    "Buildroot URL MD5 hash"
)

set(BUILDROOT_BUILD_DIR ${DEPENDS_DIR}/buildroot/${USERSPACE_PREFIX}/build
    CACHE INTERNAL
    "The build directory for the guest image"
)

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
    DEFAULT_VAL "${HAVOC_SCRIPTS_DIR}/hooks/fakeroot/xenstore.sh"
    DESCRIPTION "Hook for post-build, pre-archive customization of the image"
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
    DEFAULT_VAL ${HAVOC_CONFIG_DIR}/rootfs/xenstore/buildroot.config.in
    DESCRIPTION "The .config file used by buildroot to build the guest image"
)

add_config(
    CONFIG_NAME LINUX_CONFIG_IN
    CONFIG_TYPE FILEPATH
    DEFAULT_VAL ${HAVOC_CONFIG_DIR}/rootfs/xenstore/linux.config.in
    DESCRIPTION "The .config file for the guest kernel"
)
