#!/bin/bash
set -ex

# Removes -std=c++XX from build ${CXXFLAGS}.
# Ignores irrelevant Clang availability annotations on MacOS: 
# https://conda-forge.org/docs/maintainer/knowledge_base.html#newer-c-features-with-old-sdk
export CXXFLAGS="$(echo "${CXXFLAGS}" | sed -E 's@-std=c\+\+[^ ]+@@g') -D_LIBCPP_DISABLE_AVAILABILITY"

if [[ "$SHLIB_EXT" == '.dylib' ]]; then

  if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
  BUILD_TEST=ON
  else
  BUILD_TEST=OFF
  fi

  export CMAKE_BUILD_TYPE=Release
  export BUILD_SHARED_LIBS=ON
  export CMAKE_BUILD_WITH_INSTALL_RPATH=ON
  export CMAKE_CXX_STANDARD=17
  export TMPDIR="${SRC_DIR}\build\tmp"

  mkdir build
  pushd build
  mkdir tmp

  cmake -GNinja ${CMAKE_ARGS} \
      -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
      -DCMAKE_PREFIX_PATH="${PREFIX}" \
      -DOPENFST_BUILD_TEST=$BUILD_TEST \
      ..


  cmake --build . --verbose --config Release -- -v -j ${CPU_COUNT}
  ctest
  cmake --install . --verbose --config Release


  popd
else
  # Get an updated config.sub and config.guess
  cp $BUILD_PREFIX/share/gnuconfig/config.* .

  ./configure \
     --prefix="${PREFIX}" \
     --enable-static=no \
     --enable-compress \
     --enable-compact-fsts \
     --enable-fsts \
     --enable-far \
     --enable-grm \
     --enable-special \
     --enable-linear-fsts \
     --enable-lookahead-fsts \
     --enable-mpdt \
     --enable-ngram-fsts \
     --enable-pdt

  make -j"${CPU_COUNT}" check || (cat src/test/test-suite.log && exit 1)

  make -j"${CPU_COUNT}" install

fi

