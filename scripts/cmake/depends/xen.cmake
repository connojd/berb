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
# Xen variables
# ------------------------------------------------------------------------------

set(XEN_URL "https://github.com/connojd/xen/archive/master.zip"
    CACHE INTERNAL FORCE
    "Xen URL"
)

set(XEN_URL_MD5 "f30b475dda6681a0675e57c28f4c7d98"
    CACHE INTERNAL FORCE
    "Xen URL MD5 hash"
)

set(XEN_BUILD_DIR ${CACHE_DIR}/xen
    CACHE INTERNAL
    "Xen build directory"
)

# ------------------------------------------------------------------------------
# Download
# ------------------------------------------------------------------------------

message(STATUS "Including dependency: xen")

download_dependency(
    xen
    URL         ${XEN_URL}
    URL_MD5     ${XEN_URL_MD5}
)

# ------------------------------------------------------------------------------
# Add dependency
# ------------------------------------------------------------------------------

add_dependency(
    xen userspace
        CONFIGURE_COMMAND ${CMAKE_COMMAND} -E chdir ${XEN_BUILD_DIR} ./configure --disable-rombios --disable-seabios --disable-docs --disable-stubdom --prefix=/usr
    BUILD_COMMAND make O=${XEN_BUILD_DIR} -C ${CACHE_DIR}/xen dist-xen
        COMMAND make O=${XEN_BUILD_DIR} -C ${CACHE_DIR}/xen dist-tools
    INSTALL_COMMAND ${CMAKE_COMMAND} -E touch_nocreate kludge
)
