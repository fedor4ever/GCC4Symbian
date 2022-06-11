#!/bin/bash
#License - Attribution-NonCommercial 4.0 International

# Notes:

# Looks like isl 0.15 incompatible with gcc 5.2 : graphite-poly.h:402:35: error: 'isl_constraint' was
#	 not declared in this scope

# D:\MinGW\msys\1.0\bin\make.exe: *** couldn't commit memory for cygwin heap, Win32 error 0


# --with-newlib
# Since a working C library is not yet available, this ensures that the inhibit_libc constant
# is defined when building libgcc. This prevents the compiling of any code that requires libc support.

# --------------------
# Global variables
export TARGET=arm-none-symbianelf
GCCC=gcc-12.1.0
BINUTILS=binutils-2.35
GDB=gdb-10.2


ICONV=""
MAKEJOBS=-j4
WINDOWS_HOST=0

case "$OSTYPE" in 
  linux*)
    export PREFIX=$HOME/gcc-builds/$GCCC
    ;;
  mingw*)
# We got enviroment-free statically linked GCC
    ICONV=--with-libiconv-prefix=/usr/local
    MAKEJOBS=-j"${NUMBER_OF_PROCESSORS}"
#set SHELL=cmd.exe allow parallel build on windows
    set SHELL=cmd.exe
    export PREFIX=/usr/local/$GCCC
    WINDOWS_HOST=1
    ;;
esac

#todo: use multithread download(aria2?)
#WGET=aria
WGET=wget
# --------------------
for arg in "$GDB" "$GCCC" "$BINUTILS"
do
  if [ ! -d $arg ] ; then
    if [ ! -f $arg.tar.* ] ; then
      $WGET "https://gcc.gnu.org/pub/gdb/releases/$arg.tar.xz" "https://gcc.gnu.org/pub/gdb/releases/$arg.tar.bz2" \
        "https://gcc.gnu.org/pub/binutils/releases/$arg.tar.bz2" "https://gcc.gnu.org/pub/gcc/releases/$arg/$arg.tar.bz2" \
        "https://gcc.gnu.org/pub/gcc/releases/$arg/$arg.tar.xz"
    fi
    echo $arg
    tar -xf $arg.tar.*
  fi
done

unset CFLAGS
export CFLAGS+="-pipe -Bstatic"

# ------------------
echo "Bulding binutils pass started"

touch build-binutils-started
if [ -d ./build-binutils ] ; then
 rm -rf ./build-binutils
fi
mkdir build-binutils

cd build-binutils
../$BINUTILS/./configure --target=$TARGET --prefix=$PREFIX --disable-option-checking \
--enable-ld --enable-gold --enable-lto --enable-vtable-verify \
--enable-werror=no --without-headers --disable-nls --disable-shared \
--disable-libquadmath --enable-plugins --enable-multilib

make $MAKEJOBS
make install-strip

cd ..
touch build-binutils-finished
echo "Bulding binutils pass finished"

# _____________
echo "Copyng gcc dependency libs started"

cp -Ru sys-include $PREFIX/$TARGET

ISL=isl-0.16.1 #
GMP=gmp-6.1.0 #
MPC=mpc-1.2.1
MPFR=mpfr-4.1.0

# Strange build error in msys2
# MPC=mpc-1.0.3

for arg in "$MPC" "$ISL" "$GMP" "$MPFR"
do
  dir=`echo "$arg" | grep -Eo '^.{3}[[:alpha:]]?'`
  if [ ! -d $GCCC/$dir ] ; then
    if [ ! -f $arg.tar.* ] ; then
      $WGET "https://gcc.gnu.org/pub/gcc/infrastructure/$arg.tar.bz2" "https://gcc.gnu.org/pub/gcc/infrastructure/$arg.tar.gz"
    fi
    tar -xf $arg.tar.*
	cp -Rup $arg $GCCC/$dir
  fi
done

echo "Copyng gcc dependency libs finished"

# _____________
unset CFLAGS
# FIXME: On Devuan linux tries to statically link with nonexisted libgcc_s.a
#So -Bstatic windows only.
export CFLAGS+="-pipe"
if [ "$WINDOWS_HOST" -eq 1 ]; then
    export CFLAGS+="-pipe -Bstatic"
fi

if [ -d ./build-gcc ] ; then
 rm -rf ./build-gcc
fi
mkdir build-gcc

echo "Building gcc started"

touch build-gcc-started
cd build-gcc
../$GCCC/./configure  --target=$TARGET --prefix=$PREFIX $ICONV --without-headers \
	--enable-languages="c,c++,lto" --enable-lto --enable-interwork \
	--enable-long-long --enable-tls --enable-multilib --enable-wchar_t \
	--enable-c99 --with-newlib --with-dwarf2 --with-static-standard-libraries \
	--disable-hosted-libstdcxx --disable-libstdcxx-pch --disable-shared \
	--disable-option-checking --disable-threads --disable-nls \
	--disable-win32-registry --disable-libssp --disable-libquadmath


# use -k because build libstdc++ expectable failes
# but libsupc and other stuff should be installed!

make $MAKEJOBS -k 2> make-gcc.log
if [ "$WINDOWS_HOST" -eq 1 ]; then
# Ugly hack for:
# D:\MinGW\msys\1.0\bin\make.exe: *** couldn't commit memory for cygwin heap, Win32 error 0
# I hope this enough :-)
	touch first-make-call
	make $MAKEJOBS -k 2>> make-gcc.log
	make $MAKEJOBS -k 2>> make-gcc.log
	make $MAKEJOBS -k 2>> make-gcc.log
	make $MAKEJOBS -k 2>> make-gcc.log
	make $MAKEJOBS -k 2>> make-gcc.log
	make $MAKEJOBS -k 2>> make-gcc.log
	make $MAKEJOBS -k 2>> make-gcc.log
fi
make -k install-strip

cd ..
touch build-gcc-finished
echo "Bulding gcc finished"


unset CFLAGS
export CFLAGS+="-pipe"
if [ -d ./build-gdb ] ; then
 rm -rf ./build-gdb
fi
mkdir build-gdb


# ______________________

touch build-gdb-started
cd build-gdb

../$GDB/./configure --target=$TARGET --prefix=$PREFIX --disable-nls --disable-shared
make $MAKEJOBS 2> gdb-log.txt
make install

cd ..
touch build-gdb-finished

#Windows only
if [ "$WINDOWS_HOST" -eq 1 ]; then
    rundll32 powrprof.dll,SetSuspendState 0,1,0
fi
