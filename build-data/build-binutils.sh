
TARGET=arm-none-symbianelf
# Installation folder
GCCC=gcc-5.5.0

# MAKEJOBS=-j4
MAKEJOBS=--jobs=1

PREFIX=/usr/local/$GCCC
PATH=$PATH:$PREFIX/bin
unset CFLAGS
export CFLAGS+="-pipe"
# ------------------
BINUTILS=binutils-2.29.1

if [ -d ./build-binutils ] ; then
 rm -rf ./build-binutils
fi
mkdir build-binutils

cd build-binutils
# make distclean
../$BINUTILS/configure --target=$TARGET --prefix=$PREFIX \
--enable-ld --enable-vtable-verify --enable-werror=no \
--without-headers --disable-nls --disable-shared \
--disable-libstdcxx --disable-libquadmath --enable-plugins \
--enable-multilib --enable-gold --enable-lto

make $MAKEJOBS
make install-strip
# make install-pdf
cd ..

rundll32 powrprof.dll,SetSuspendState 0,1,0