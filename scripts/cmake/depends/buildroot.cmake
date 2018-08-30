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

message(STATUS "Including dependency: buildroot")

download_dependency(
    buildroot
    URL         ${BUILDROOT_URL}
    URL_MD5     ${BUILDROOT_URL_MD5}
)

if(WIN32 OR CYGWIN OR NOT ENABLE_BUILD_VMM)
    return()
endif()

configure_file(
    ${BUILDROOT_CONFIG_IN}
    ${BUILDROOT_BUILD_DIR}/.config
    @ONLY
    NEWLINE_STYLE UNIX
)

#add_custom_command(
#    OUTPUT ${BUILDROOT_BUILD_DIR}/../stamp/linux_${USERSPACE_PREFIX}-update.much-kludge
#    COMMAND ${CMAKE_COMMAND} -E touch ${BUILDROOT_BUILD_DIR}/../stamp/linux_${USERSPACE_PREFIX}-update.much-kludge
#    COMMAND ${CMAKE_COMMAND} -E touch ${BUILDROOT_BUILD_DIR}/../stamp/linux_${USERSPACE_PREFIX}-update
#    DEPENDS ${BUILDROOT_CONFIG_IN}
#)
#add_custom_target(
#    stamp-much-kludge
#    COMMAND ""
#    DEPENDS ${BUILDROOT_BUILD_DIR}/../stamp/linux_${USERSPACE_PREFIX}-update.much-kludge
#)
#
#add_custom_command(
#    OUTPUT ${BUILDROOT_BUILD_DIR}/../stamp/linux_${USERSPACE_PREFIX}-update.very-kludge
#    COMMAND ${CMAKE_COMMAND} -E touch ${BUILDROOT_BUILD_DIR}/../stamp/linux_${USERSPACE_PREFIX}-update.very-kludge
#    COMMAND ${CMAKE_COMMAND} -E touch ${BUILDROOT_BUILD_DIR}/../stamp/linux_${USERSPACE_PREFIX}-update
#    DEPENDS ${BUILDROOT_INITRAMFS_IN}
#)
#add_custom_target(
#    stamp-very-kludge
#    COMMAND ""
#    DEPENDS ${BUILDROOT_BUILD_DIR}/../stamp/linux_${USERSPACE_PREFIX}-update.very-kludge
#)

add_dependency(
    buildroot userspace
    CONFIGURE_COMMAND make CC=gcc O=${BUILDROOT_BUILD_DIR} -C ${CACHE_DIR}/buildroot olddefconfig
    BUILD_COMMAND     make CC=gcc O=${BUILDROOT_BUILD_DIR} -C ${CACHE_DIR}/buildroot
    INSTALL_COMMAND   /bin/true
)
