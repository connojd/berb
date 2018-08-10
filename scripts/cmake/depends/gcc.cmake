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

if(NOT CYGWIN OR NOT ENABLE_BUILD_GCC)
    return()
endif()

message(STATUS "Including dependency: gcc")
download_dependency(
    gcc
    URL         ${GCC_URL}
    URL_MD5     ${GCC_URL_MD5}
)

message(STATUS "Including dependency: gmp")
download_dependency(
    gmp
    URL         ${GMP_URL}
    URL_MD5     ${GMP_URL_MD5}
)

message(STATUS "Including dependency: mpc")
download_dependency(
    mpc
    URL         ${MPC_URL}
    URL_MD5     ${MPC_URL_MD5}
)

message(STATUS "Including dependency: mpfr")
download_dependency(
    mpfr
    URL         ${MPFR_URL}
    URL_MD5     ${MPFR_URL_MD5}
)

list(APPEND GCC_CONFIGURE_FLAGS
    --disable-nls
    --disable-werror
    --with-sysroot
    --with-gmp=${CACHE_DIR}/gmp
    --with-mpc=${CACHE_DIR}/mpc
    --with-mpfr=${CACHE_DIR}/mpfr
    --prefix=${PREFIXES_DIR}
    --target=${VMM_PREFIX}
)

add_dependency(
    gcc vmm
    CONFIGURE_COMMAND   ${CACHE_DIR}/gcc/configure ${GCC_CONFIGURE_FLAGS}
    BUILD_COMMAND       make -j${BUILD_TARGET_CORES}
    INSTALL_COMMAND     make install
)
