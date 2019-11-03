./configure \
   --prefix="${PREFIX}" \
   --enable-compact-fsts \
   --enable-compress \
   --enable-const-fsts \
   --enable-far \
   --enable-linear-fsts \
   --enable-lookahead-fsts \
   --enable-mpdt \
   --enable-ngram-fsts \
   --enable-pdt \
   --enable-special

make -j"${CPU_COUNT}"
make -j"${CPU_COUNT}" install
