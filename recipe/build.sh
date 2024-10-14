#!/bin/bash
set -ex

# Removes -std=c++XX from build ${CXXFLAGS}.
# Ignores irrelevant Clang availability annotations on MacOS: 
# https://conda-forge.org/docs/maintainer/knowledge_base.html#newer-c-features-with-old-sdk
export CXXFLAGS="$(echo "${CXXFLAGS}" | sed -E 's@-std=c\+\+[^ ]+@@g') -D_LIBCPP_DISABLE_AVAILABILITY"

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
ctest --rerun-failed --output-on-failure
cmake --install . --verbose --config Release

popd
