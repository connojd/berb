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

# ------------------------------------------------------------------------------
# Source tree
# ------------------------------------------------------------------------------

set(ERB_IMAGE_DIR ${CMAKE_CURRENT_LIST_DIR}/image
    CACHE INTERNAL
    "Directory for storing configuration files for guest images"
)

set(ERB_TOOLS_DIR ${CMAKE_CURRENT_LIST_DIR}/tools
    CACHE INTERNAL
    "Directory for storing configuration files for cross tools"
)

set(ERB_SCRIPTS_DIR ${CMAKE_CURRENT_LIST_DIR}/scripts
    CACHE INTERNAL
    "Directory for storing script files (cmake, bash, etc)"
)

set(ERB_CMAKE_DIR ${CMAKE_CURRENT_LIST_DIR}/scripts/cmake
    CACHE INTERNAL
    "CMake script directory"
)

set(ERB_DEPENDS_DIR ${CMAKE_CURRENT_LIST_DIR}/scripts/cmake/depends
    CACHE INTERNAL
    "Dependency directory"
)

# ------------------------------------------------------------------------------
# Default config
# ------------------------------------------------------------------------------

include(${CMAKE_CURRENT_LIST_DIR}/scripts/cmake/config/default.cmake)

# ------------------------------------------------------------------------------
# Dependencies
# ------------------------------------------------------------------------------

include_dependency(ERB_DEPENDS_DIR crosstool)
include_dependency(ERB_DEPENDS_DIR buildroot)
