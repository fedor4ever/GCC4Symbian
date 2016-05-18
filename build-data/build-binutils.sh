
TARGET=arm-none-symbianelf
# Installation folder
GCCC=gcc-6.1.0
PREFIX=/usr/local/$GCCC
PATH=$PATH:$PREFIX/bin
unset CFLAGS
export CFLAGS+="-pipe"
# ------------------
BINUTILS=binutils-2.26

if [ -d ./build-binutils2 ] ; then
 rm -rf ./build-binutils2
 mkdir build-binutils2
else
 mkdir build-binutils2
fi

cd build-binutils2
make clean
# make distclean
../$BINUTILS/configure --target=$TARGET --prefix=$PREFIX \
--enable-ld --enable-vtable-verify --enable-werror=no \
--without-headers --disable-nls --disable-shared \
--disable-libstdcxx --disable-libquadmath --enable-plugins \
--enable-multilib --enable-gold --enable-lto

make
make all-gold
make install-strip
# make install-pdf
cd ..

rundll32 powrprof.dll,SetSuspendState 0,1,0