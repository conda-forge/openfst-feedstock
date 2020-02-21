./configure \
   --prefix="${PREFIX}" \
   --enable-compress \
   --enable-fsts \
   --enable-grm \
   --enable-special
make -j"${CPU_COUNT}" check
make -j"${CPU_COUNT}" install
