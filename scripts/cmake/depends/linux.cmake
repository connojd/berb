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

if(EXISTS ${LINUX_INITRAMFS_IMAGE})
    set(LINUX_INITRAMFS_SOURCE ${LINUX_INITRAMFS_IMAGE})
    file(APPEND ${LINUX_INITRAMFS_IN} "")
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

add_custom_command(
    OUTPUT ${LINUX_BUILD_DIR}/../stamp/linux_${USERSPACE_PREFIX}-update.much-kludge
    COMMAND ${CMAKE_COMMAND} -E touch ${LINUX_BUILD_DIR}/../stamp/linux_${USERSPACE_PREFIX}-update.much-kludge
    COMMAND ${CMAKE_COMMAND} -E touch ${LINUX_BUILD_DIR}/../stamp/linux_${USERSPACE_PREFIX}-update
    DEPENDS ${LINUX_CONFIG_IN}
)
add_custom_target(
    stamp-much-kludge
    COMMAND ""
    DEPENDS ${LINUX_BUILD_DIR}/../stamp/linux_${USERSPACE_PREFIX}-update.much-kludge
)

add_custom_command(
    OUTPUT ${LINUX_BUILD_DIR}/../stamp/linux_${USERSPACE_PREFIX}-update.very-kludge
    COMMAND ${CMAKE_COMMAND} -E touch ${LINUX_BUILD_DIR}/../stamp/linux_${USERSPACE_PREFIX}-update.very-kludge
    COMMAND ${CMAKE_COMMAND} -E touch ${LINUX_BUILD_DIR}/../stamp/linux_${USERSPACE_PREFIX}-update
    DEPENDS ${LINUX_INITRAMFS_IN}
)
add_custom_target(
    stamp-very-kludge
    COMMAND ""
    DEPENDS ${LINUX_BUILD_DIR}/../stamp/linux_${USERSPACE_PREFIX}-update.very-kludge
)

add_dependency(
    linux userspace
    CONFIGURE_COMMAND make CC=gcc O=${LINUX_BUILD_DIR} -C ${CACHE_DIR}/linux olddefconfig
    BUILD_COMMAND     make CC=gcc O=${LINUX_BUILD_DIR} -C ${CACHE_DIR}/linux -j${BUILD_TARGET_CORES}
    INSTALL_COMMAND   sudo make O=${LINUX_BUILD_DIR} -C ${CACHE_DIR}/linux modules_install
    DEPENDS stamp-much-kludge
    DEPENDS stamp-very-kludge
)
