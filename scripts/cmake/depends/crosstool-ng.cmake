#
# Excellent Rootfs Builder
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

message(STATUS "Including dependency: crosstool-ng")

download_dependency(
    crosstool-ng
    URL         ${CT_URL}
    URL_MD5     ${CT_URL_MD5}
)

# Any @VAR@'s defined in ${CT_CONFIG_IN} have to be
# passed with -D here
set(BR2_CONFIG_OUT "${BR2_BUILD_DIR}/.config")
add_dependency(
    crosstool-ng userspace
    CONFIGURE_COMMAND ${CMAKE_COMMAND} -E make_directory ${CACHE_DIR}/crosstool-ng/${CT_TARGET}/src
    COMMAND ${CMAKE_COMMAND}
        -DCT_TARGET=${CT_TARGET}
        -DCT_TARGET_VENDOR=${CT_TARGET_VENDOR}
        -DCT_PREFIX_DIR=${CT_PREFIX_DIR}
        -DCT_BUILD_DIR=${CT_BUILD_DIR}
        -DCACHE_DIR=${CACHE_DIR}
        -DCT_CONFIG_IN=${CACHE_DIR}/crosstool-ng/samples/${CT_TARGET}/crosstool.config.in
        -DCT_CONFIG_OUT=${CACHE_DIR}/crosstool-ng/samples/${CT_TARGET}/crosstool.config
        -P ${ERB_CMAKE_DIR}/config/configure-crosstool-ng.cmake
    COMMAND ${CMAKE_COMMAND} -E chdir ${CACHE_DIR}/crosstool-ng ./bootstrap
    COMMAND ${CMAKE_COMMAND} -E chdir ${CACHE_DIR}/crosstool-ng ./configure --enable-local

    BUILD_COMMAND ${CMAKE_COMMAND} -E chdir ${CACHE_DIR}/crosstool-ng make
    INSTALL_COMMAND ${CMAKE_COMMAND} -E touch_nocreate kludge
)

ExternalProject_Add_Step(crosstool-ng_${USERSPACE_PREFIX} build-toolchain
    COMMAND ${CMAKE_COMMAND} -E chdir ${CACHE_DIR}/crosstool-ng ./ct-ng ${CT_TARGET}
    COMMAND ${CMAKE_COMMAND} -E chdir ${CACHE_DIR}/crosstool-ng ./ct-ng build
    DEPENDEES install
)
