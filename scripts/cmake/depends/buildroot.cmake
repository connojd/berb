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

configure_file(
    ${BUILDROOT_CONFIG_IN}
    ${BUILDROOT_BUILD_DIR}/.config
    @ONLY
    NEWLINE_STYLE UNIX
)

add_dependency(
    buildroot userspace
    CONFIGURE_COMMAND make CC=gcc O=${BUILDROOT_BUILD_DIR} -C ${CACHE_DIR}/buildroot silentoldconfig
    BUILD_COMMAND     make CC=gcc O=${BUILDROOT_BUILD_DIR} -C ${CACHE_DIR}/buildroot
    INSTALL_COMMAND   ""
)

ExternalProject_Add_Step(buildroot_${USERSPACE_PREFIX} reconfigure
    COMMAND
        ${CMAKE_COMMAND}
        -DBUILDROOT_CONFIG_IN=${BUILDROOT_CONFIG_IN}
        -DBUILDROOT_BUILD_DIR=${BUILDROOT_BUILD_DIR}
        -DLINUX_CONFIG=${LINUX_CONFIG}
        -P ${HAVOC_CONFIG_DIR}/buildroot/reconfigure.cmake
    DEPENDERS build
    DEPENDEES configure
    DEPENDS ${BUILDROOT_CONFIG_IN}
)
