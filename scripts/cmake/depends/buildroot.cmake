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

if(WIN32 OR CYGWIN OR NOT ENABLE_BUILD_VMM)
    return()
endif()

message(STATUS "Including dependency: buildroot")

download_dependency(
    buildroot
    URL         ${BUILDROOT_URL}
    URL_MD5     ${BUILDROOT_URL_MD5}
)

add_dependency(
    buildroot userspace
    CONFIGURE_COMMAND ${CMAKE_COMMAND} -E touch_nocreate kludge
    BUILD_COMMAND     make CC=gcc O=${BUILDROOT_BUILD_DIR} -C ${CACHE_DIR}/buildroot
    INSTALL_COMMAND   ""
)


# Any @VAR@'s defined in ${LINUX_CONFIG_IN} have to be
# passed with -D here
# TODO: find a way that scales better
set(LINUX_CONFIG_OUT "${BUILDROOT_BUILD_DIR}/.linux-config")

ExternalProject_Add_Step(buildroot_${USERSPACE_PREFIX} configure-linux
    COMMAND
        ${CMAKE_COMMAND}
        -DLINUX_CONFIG_IN=${LINUX_CONFIG_IN}
        -DLINUX_CONFIG_OUT=${LINUX_CONFIG_OUT}
        -P ${HAVOC_CMAKE_DIR}/config/configure-linux.cmake
    DEPENDEES configure
    DEPENDS ${LINUX_CONFIG_IN}
)

# Any @VAR@'s defined in ${BUILDROOT_CONFIG_IN} have to be
# passed with -D here
set(BUILDROOT_CONFIG_OUT "${BUILDROOT_BUILD_DIR}/.config")

ExternalProject_Add_Step(buildroot_${USERSPACE_PREFIX} configure-buildroot
    COMMAND
        ${CMAKE_COMMAND}
        -DLINUX_CONFIG_OUT=${LINUX_CONFIG_OUT}
        -DBUILDROOT_CONFIG_IN=${BUILDROOT_CONFIG_IN}
        -DBUILDROOT_CONFIG_OUT=${BUILDROOT_CONFIG_OUT}
        -P ${HAVOC_CMAKE_DIR}/config/configure-buildroot.cmake
    DEPENDEES configure-linux
    DEPENDERS build
    DEPENDS ${BUILDROOT_CONFIG_IN}
)
