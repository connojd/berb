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

if(ENABLE_BUILD_VMM)
    if(NOT WIN32)

        # This must come before configure_file
        set(INITRAMFS_SRC_FILE ${INITRAMFS_LIST})
        if(EXISTS ${INITRAMFS_IMAGE})
            set(INITRAMFS_SRC_FILE ${INITRAMFS_IMAGE})
        endif()

        configure_file(
            ${LINUX_CONFIG_FILE}
            ${LINUX_OUTPUT_DIR}/.config
            @ONLY
            NEWLINE_STYLE UNIX
        )

        add_dependency(
            linux userspace
            CONFIGURE_COMMAND make O=${LINUX_OUTPUT_DIR} -C ${CACHE_DIR}/linux olddefconfig
            BUILD_COMMAND     make O=${LINUX_OUTPUT_DIR} -C ${CACHE_DIR}/linux -j${BUILD_TARGET_CORES}
            INSTALL_COMMAND   /usr/bin/true
        )
    endif()
endif()
