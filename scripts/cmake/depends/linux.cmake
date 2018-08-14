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

message(STATUS "Including dependency: linux")

download_dependency(
    linux
    URL         ${LINUX_URL}
    URL_MD5     ${LINUX_URL_MD5}
)

if(WIN32 OR CYGWIN OR NOT ENABLE_BUILD_VMM)
    return()
endif()

#
# This must come before configure_file. If an existing image path is
# set by the user, it takes priority over any list file.
#

if(EXISTS ${INITRAMFS_IMAGE})
    set(LINUX_INITRAMFS_SOURCE ${INITRAMFS_IMAGE})
else()
    configure_file(
        ${LINUX_INITRAMFS_IN}
        ${LINUX_BUILD_DIR}/.initramfs.list
        @ONLY
        NEWLINE_STYLE UNIX
    )
    set(LINUX_INITRAMFS_SOURCE ${LINUX_BUILD_DIR}/.initramfs.list)
endif()

#
# Now that initramfs source is set, we configure .config.in -> .config
# for the linux build and add the dependency.
#

configure_file(
    ${LINUX_CONFIG_IN}
    ${LINUX_BUILD_DIR}/.config
    @ONLY
    NEWLINE_STYLE UNIX
)

add_dependency(
    linux userspace
    CONFIGURE_COMMAND make CC=gcc O=${LINUX_BUILD_DIR} -C ${CACHE_DIR}/linux olddefconfig
    BUILD_COMMAND     make CC=gcc O=${LINUX_BUILD_DIR} -C ${CACHE_DIR}/linux -j${BUILD_TARGET_CORES}
    INSTALL_COMMAND   /bin/true
)
