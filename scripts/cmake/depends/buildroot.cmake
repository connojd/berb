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

if(WIN32 OR CYGWIN)
    return()
endif()

# ------------------------------------------------------------------------------
# Buildroot (BR2) variables
# ------------------------------------------------------------------------------

set(BR2_URL "https://buildroot.org/downloads/buildroot-2018.08.tar.gz"
    CACHE INTERNAL FORCE
    "Buildroot URL"
)

set(BR2_URL_MD5 "8cc486858fc7812388dd82c27c3a2dcc"
    CACHE INTERNAL FORCE
    "Buildroot URL MD5 hash"
)

set(BR2_BUILD_DIR "${DEPENDS_DIR}/buildroot/${USERSPACE_PREFIX}/build/${IMAGE}"
    CACHE INTERNAL
    "The build directory for the guest image"
)

set(BR2_CONFIG_OUT "${BR2_BUILD_DIR}/.config"
    CACHE INTERNAL
    "The final buildroot config file"
)

set(LINUX_CONFIG_OUT "${BR2_BUILD_DIR}/.linux-config"
    CACHE INTERNAL
    "The final linux config file"
)

# ------------------------------------------------------------------------------
# Download
# ------------------------------------------------------------------------------

message(STATUS "Including dependency: buildroot")

download_dependency(
    buildroot
    URL         ${BR2_URL}
    URL_MD5     ${BR2_URL_MD5}
)

# ------------------------------------------------------------------------------
# Setup root overlay
# ------------------------------------------------------------------------------

if(IMAGE STREQUAL "xenstore")
    include_dependency(ERB_DEPENDS_DIR xen)
    set(BR2_ROOTFS_OVERLAY ${XEN_BUILD_DIR}/dist/install)
endif()

if(IMAGE STREQUAL "tiny")
    set(BR2_ROOTFS_OVERLAY ${ERB_IMAGE_DIR}/${IMAGE}/overlay)
endif()

# ------------------------------------------------------------------------------
# Add dependency
#
# NOTE: Any @VAR@'s defined in ${LINUX_CONFIG_IN} have to be passed with -D here
# ------------------------------------------------------------------------------

if(CT_PREFIX_DIR STREQUAL "")
    set(CT_PREFIX_DIR ${DEPENDS_DIR}/../../xtools/${CT_TUPLE})
    include_dependency(ERB_DEPENDS_DIR crosstool)
    add_dependency(
        buildroot userspace
        CONFIGURE_COMMAND ${CMAKE_COMMAND} -E touch_nocreate kludge
        BUILD_COMMAND make O=${BR2_BUILD_DIR} -C ${CACHE_DIR}/buildroot olddefconfig
            COMMAND make O=${BR2_BUILD_DIR} -C ${CACHE_DIR}/buildroot
        INSTALL_COMMAND ${CMAKE_COMMAND} -E touch_nocreate kludge
        DEPENDS crosstool_${USERSPACE_PREFIX}
        BUILD_ALWAYS TRUE
    )
else()
    add_dependency(
        buildroot userspace
        CONFIGURE_COMMAND ${CMAKE_COMMAND} -E touch_nocreate kludge
        BUILD_COMMAND make O=${BR2_BUILD_DIR} -C ${CACHE_DIR}/buildroot olddefconfig
            COMMAND make O=${BR2_BUILD_DIR} -C ${CACHE_DIR}/buildroot
        INSTALL_COMMAND ${CMAKE_COMMAND} -E touch_nocreate kludge
        BUILD_ALWAYS TRUE
    )
endif()


# ------------------------------------------------------------------------------
# Add dependency steps
#
# NOTE: Any @VAR@'s defined in ${BR2_CONFIG_IN} have to be passed with -D here
# ------------------------------------------------------------------------------

ExternalProject_Add_Step(buildroot_${USERSPACE_PREFIX} config-linux
    COMMAND
        ${CMAKE_COMMAND}
        -DLINUX_CONFIG_IN=${LINUX_CONFIG_IN}
        -DLINUX_CONFIG_OUT=${LINUX_CONFIG_OUT}
        -P ${ERB_CMAKE_DIR}/config/config-linux.cmake
    DEPENDEES configure
    DEPENDS ${LINUX_CONFIG_IN}
)

ExternalProject_Add_Step(buildroot_${USERSPACE_PREFIX} config-buildroot
    COMMAND
        ${CMAKE_COMMAND}
        -DLINUX_CONFIG_OUT=${LINUX_CONFIG_OUT}
        -DBR2_CONFIG_IN=${BR2_CONFIG_IN}
        -DBR2_CONFIG_OUT=${BR2_CONFIG_OUT}
        -DBR2_ROOTFS_OVERLAY=${BR2_ROOTFS_OVERLAY}
        -DBR2_ROOTFS_POST_FAKEROOT_HOOKS=${BR2_ROOTFS_POST_FAKEROOT_HOOKS}
        -DCT_PREFIX_DIR=${CT_PREFIX_DIR}
        -DCT_TUPLE=${CT_TUPLE}
        -P ${ERB_CMAKE_DIR}/config/config-buildroot.cmake
    DEPENDEES config-linux
    DEPENDERS build
    DEPENDS ${BR2_CONFIG_IN}
)

if(IMAGE STREQUAL "xenstore")
    ExternalProject_Add_StepDependencies(
        buildroot_${USERSPACE_PREFIX}
        config-buildroot
        xen_${USERSPACE_PREFIX}
    )
endif()

add_custom_target_category("ERB Guest Image")
add_custom_target(image DEPENDS buildroot_${USERSPACE_PREFIX})
add_custom_target_info(TARGET image COMMENT "Build guest image: ${IMAGE}")
