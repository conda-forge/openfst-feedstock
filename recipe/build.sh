# Removes -std=c++XX from build ${CXXFLAGS}.
export CXXFLAGS=$(echo "${CXXFLAGS}" | sed -E 's@-std=c\+\+[^ ]+@@g')

./configure \
   --prefix="${PREFIX}" \
   --enable-compress \
   --enable-fsts \
   --enable-grm \
   --enable-special
make -j"${CPU_COUNT}" check
make -j"${CPU_COUNT}" install
