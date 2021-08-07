
TARGET=arm-none-symbianelf
# Installation folder
GCCC=gcc-11.2.0
BINUTILS=binutils-2.35


PREFIX=/usr/local/$GCCC
PATH=$PATH:$PREFIX/bin
unset CFLAGS
export CFLAGS+="-pipe"

MAKEJOBS=-j1
#Windows only
#set SHELL=cmd.exe allow parallel build on windows
if [ -z "${NUMBER_OF_PROCESSORS}" ]; then
    MAKEJOBS=-j"${NUMBER_OF_PROCESSORS}"
	echo "MAKEJOBS"
	set SHELL=cmd.exe
fi

if [ -d ./build-binutils ] ; then
 rm -rf ./build-binutils
fi
mkdir build-binutils

cd build-binutils
# make distclean
../$BINUTILS/./configure --target=$TARGET --prefix=$PREFIX \
--enable-ld --enable-vtable-verify --enable-werror=no \
--without-headers --disable-nls --disable-shared \
--disable-libstdcxx --disable-libquadmath --enable-plugins \
--enable-multilib --enable-gold --enable-lto

make $MAKEJOBS
make install-strip
# make install-pdf
cd ..
