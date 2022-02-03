# Removes -std=c++XX from build ${CXXFLAGS}.
# Ignores irrelevant Clang availability annotations on MacOS: 
# https://conda-forge.org/docs/maintainer/knowledge_base.html#newer-c-features-with-old-sdk
export CXXFLAGS="$(echo "${CXXFLAGS}" | sed -E 's@-std=c\+\+[^ ]+@@g') -D_LIBCPP_DISABLE_AVAILABILITY"

./configure \
   --prefix="${PREFIX}" \
   --enable-compress \
   --enable-fsts \
   --enable-grm \
   --enable-special
make -j"${CPU_COUNT}" check
make -j"${CPU_COUNT}" install
