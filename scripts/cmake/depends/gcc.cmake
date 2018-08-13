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

#message(STATUS "Including dependency: gmp")
#download_dependency(
#    gmp
#    URL         ${GMP_URL}
#    URL_MD5     ${GMP_URL_MD5}
#)
#
#message(STATUS "Including dependency: mpc")
#download_dependency(
#    mpc
#    URL         ${MPC_URL}
#    URL_MD5     ${MPC_URL_MD5}
#)
#
#message(STATUS "Including dependency: mpfr")
#download_dependency(
#    mpfr
#    URL         ${MPFR_URL}
#    URL_MD5     ${MPFR_URL_MD5}
#)

#set(CC_FOR_TARGET clang)
#set(CXX_FOR_TARGET clang)
#
#set(AR_FOR_TARGET ar)
#set(AS_FOR_TARGET as)
#set(NM_FOR_TARGET nm)
#set(OBJCOPY_FOR_TARGET objcopy)
#set(OBJDUMP_FOR_TARGET objdump)
#set(RANLIB_FOR_TARGET ranlib)
#set(READELF_FOR_TARGET readelf)
#set(STRIP_FOR_TARGET strip)
#
#if(DEFINED ENV{LD_BIN})
#    set(LD_FOR_TARGET $ENV{LD_BIN})
#else()
#    set(LD_FOR_TARGET ${VMM_PREFIX_PATH}/bin/ld)
#endif()

generate_flags(
    vmm
    NOWARNINGS
)

#string(CONCAT LD_FLAGS
#    "--sysroot=${CMAKE_INSTALL_PREFIX} "
#    "-z max-page-size=4096 "
#    "-z common-page-size=4096 "
#    "-z relro "
#    "-z now "
#    "-nostdlib "
#)

list(APPEND GCC_CONFIGURE_FLAGS
    --srcdir=${CACHE_DIR}/gcc
    --disable-nls
    --disable-shared
    --disable-werror
    --disable-multilib
    --disable-decimal-float
    --disable-threads
    --disable-libatomic
    --disable-libgomp
    --disable-libmpx
    --disable-libquadmath
    --disable-libssp
    --disable-libvtv
    --disable-libstdcxx
    --disable-libsanitizer
    --enable-languages=c
    --with-newlib
    --with-sysroot=${VMM_PREFIX_PATH}
    --with-local-prefix=${VMM_PREFIX_PATH}
    --with-native-system-header-dir=/include

    --with-gmp-include=/usr/include
    --with-mpc-include=/usr/include
    --with-mpfr-include=/usr/include

    --with-gmp-lib=/lib
    --with-mpc-lib=/lib
    --with-mpfr-lib=/lib

    --prefix=${PREFIXES_DIR}
    --target=${VMM_PREFIX}
)

set(GCC_BUILD_DIR ${DEPENDS_DIR}/gcc/${VMM_PREFIX}/build)

add_dependency(
    gcc vmm
    CONFIGURE_COMMAND   ${CMAKE_CURRENT_LIST_DIR}/config-gcc.sh ${CACHE_DIR} ${GCC_BUILD_DIR} "${GCC_CONFIGURE_FLAGS}"
    BUILD_COMMAND       make -C ${GCC_BUILD_DIR} -j${BUILD_TARGET_CORES}
    INSTALL_COMMAND     make -C ${GCC_BUILD_DIR} install
    DEPENDS             newlib_${VMM_PREFIX}
)
