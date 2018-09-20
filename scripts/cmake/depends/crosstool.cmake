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

# ------------------------------------------------------------------------------
# Crosstool (CT) variables
# ------------------------------------------------------------------------------

set(CT_URL "https://github.com/connojd/crosstool-ng/archive/master.zip"
    CACHE INTERNAL FORCE
    "Crosstool URL"
)

set(CT_URL_MD5 "f99277c12ca98f0d7ffe327c22f5b59a"
    CACHE INTERNAL FORCE
    "Crosstool URL MD5 hash"
)

set(CT_BUILD_DIR ${DEPENDS_DIR}/crosstool/${USERSPACE_PREFIX}/build
    CACHE INTERNAL
    "The build dir for the toolchain targeting the guest image"
)

# ------------------------------------------------------------------------------
# Download
# ------------------------------------------------------------------------------

message(STATUS "Including dependency: crosstool")

download_dependency(
    crosstool
    URL         ${CT_URL}
    URL_MD5     ${CT_URL_MD5}
)

# ------------------------------------------------------------------------------
# Add dependency
#
# NOTE: Any @VAR@'s defined in ${CT_CONFIG_IN} have to be passed with -D here
# ------------------------------------------------------------------------------

add_dependency(
    crosstool userspace
    STEP_TARGETS install
    CONFIGURE_COMMAND ${CMAKE_COMMAND} -E make_directory ${CACHE_DIR}/crosstool/${TUPLE}/src
        COMMAND ${CMAKE_COMMAND}
            -DCACHE_DIR=${CACHE_DIR}
            -DCT_BUILD_DIR=${CT_BUILD_DIR}
            -DCT_PREFIX_DIR=${CT_BUILD_DIR}/x-tools/${TUPLE}
            -DCT_CONFIG_IN=${ERB_TOOLCHAIN_DIR}/${TUPLE}/crosstool.config.in
            -DCT_CONFIG_OUT=${CACHE_DIR}/crosstool/samples/${TUPLE}/crosstool.config
            -P ${ERB_CMAKE_DIR}/config/config-crosstool.cmake
        COMMAND ${CMAKE_COMMAND} -E chdir ${CACHE_DIR}/crosstool ./bootstrap
        COMMAND ${CMAKE_COMMAND} -E chdir ${CACHE_DIR}/crosstool ./configure --enable-local
    BUILD_COMMAND ${CMAKE_COMMAND} -E chdir ${CACHE_DIR}/crosstool make
    INSTALL_COMMAND ${CMAKE_COMMAND} -E touch_nocreate kludge
)

ExternalProject_Add_Step(crosstool_${USERSPACE_PREFIX} build-toolchain
    COMMAND ${CMAKE_COMMAND} -E chdir ${CACHE_DIR}/crosstool ./ct-ng ${TUPLE}
    COMMAND ${CMAKE_COMMAND} -E chdir ${CACHE_DIR}/crosstool ./ct-ng build
    DEPENDEES install
)

# ------------------------------------------------------------------------------
# Add target
# ------------------------------------------------------------------------------

add_custom_target_category("ERB Toolchain")
add_custom_target(toolchain DEPENDS crosstool_${USERSPACE_PREFIX})
add_custom_target_info(TARGET toolchain COMMENT "Build toolchain: ${TUPLE}")
