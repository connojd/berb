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

if(WIN32 OR CYGWIN OR NOT ENABLE_BUILD_VMM)
    return()
endif()

message(STATUS "Including dependency: buildroot")

download_dependency(
    buildroot
    URL         ${BR2_URL}
    URL_MD5     ${BR2_URL_MD5}
)

add_dependency(
    buildroot userspace
    CONFIGURE_COMMAND ${CMAKE_COMMAND} -E touch_nocreate kludge
    BUILD_COMMAND make O=${BR2_BUILD_DIR} -C ${CACHE_DIR}/buildroot olddefconfig
    COMMAND make O=${BR2_BUILD_DIR} -C ${CACHE_DIR}/buildroot
    INSTALL_COMMAND ${CMAKE_COMMAND} -E touch_nocreate kludge
)


# Any @VAR@'s defined in ${LINUX_CONFIG_IN} have to be
# passed with -D here
# TODO: find a way that scales better
set(LINUX_CONFIG_OUT "${BR2_BUILD_DIR}/.linux-config")

ExternalProject_Add_Step(buildroot_${USERSPACE_PREFIX} configure-linux
    COMMAND
        ${CMAKE_COMMAND}
        -DLINUX_CONFIG_IN=${LINUX_CONFIG_IN}
        -DLINUX_CONFIG_OUT=${LINUX_CONFIG_OUT}
        -P ${ERB_CMAKE_DIR}/config/configure-linux.cmake
    DEPENDEES configure
    DEPENDS ${LINUX_CONFIG_IN}
)

# Any @VAR@'s defined in ${BR2_CONFIG_IN} have to be
# passed with -D here
set(BR2_CONFIG_OUT "${BR2_BUILD_DIR}/.config")

ExternalProject_Add_Step(buildroot_${USERSPACE_PREFIX} configure-buildroot
    COMMAND
        ${CMAKE_COMMAND}
        -DLINUX_CONFIG_OUT=${LINUX_CONFIG_OUT}
        -DBR2_CONFIG_IN=${BR2_CONFIG_IN}
        -DBR2_CONFIG_OUT=${BR2_CONFIG_OUT}
        -DCT_TARGET=${CT_TARGET}
        -DCT_PREFIX_DIR=${CT_PREFIX_DIR}
        -P ${ERB_CMAKE_DIR}/config/configure-buildroot.cmake
    DEPENDEES configure-linux
    DEPENDERS build
    DEPENDS ${BR2_CONFIG_IN}
)
