#!/bin/bash

cache_dir=$1
build_dir=$2
shift 2

cp -r $cache_dir/{gmp,mpc,mpfr} $cache_dir/gcc/
mkdir -p $build_dir
pushd $build_dir
$cache_dir/gcc/configure "$@"
popd
