#!/bin/bash
set -ex

# Removes -std=c++XX from build ${CXXFLAGS}.
# Ignores irrelevant Clang availability annotations on MacOS: 
# https://conda-forge.org/docs/maintainer/knowledge_base.html#newer-c-features-with-old-sdk
export CXXFLAGS="$(echo "${CXXFLAGS}" | sed -E 's@-std=c\+\+[^ ]+@@g') -D_LIBCPP_DISABLE_AVAILABILITY"

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .

if [[ "${CONDA_BUILD_CROSS_COMPILATION}" == "1" ]]; then
  OPENFST_CROSS_COMPILATION_CONFIGURE_OPTS="--build=${BUILD} --host=${HOST}"
else
  OPENFST_CROSS_COMPILATION_CONFIGURE_OPTS=""
fi

./configure \
   --prefix="${PREFIX}" \
   --enable-static=no \
   --enable-compress \
   --enable-fsts \
   --enable-grm \
   --enable-special \
   ${OPENFST_CROSS_COMPILATION_CONFIGURE_OPTS}

if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" && "$SHLIB_EXT" != '.dylib' ]]; then
  make -j"${CPU_COUNT}" check || (cat src/test/test-suite.log && exit 1)
fi

make -j"${CPU_COUNT}" install
