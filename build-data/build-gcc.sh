
export TARGET=arm-none-symbianelf
# Installation folder
export GCCC=gcc-12.1.0

# I want have enviroment-free statically linked GCC
ICONV=""

unset CFLAGS
# FIXME: On Devuan linux tries to statically link with nonexisted libgcc_s.a
#So -Bstatic windows only.
export CFLAGS+="-pipe"
if [ "$WINDOWS_HOST" -eq 1 ]; then
    export CFLAGS+=" -Bstatic"
fi

MAKEJOBS=-j6
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
  msys*)
# We got enviroment-free statically linked GCC
    ICONV=--with-libiconv-prefix=/g/MinGW/msys/1.0/local
    MAKEJOBS=-j"${NUMBER_OF_PROCESSORS}"
#set SHELL=cmd.exe allow parallel build on windows
    set SHELL=cmd.exe
    export PREFIX=/g/MinGW/msys/1.0/local/$GCCC
    WINDOWS_HOST=1
    ;;
esac
export PATH=$PATH:$PREFIX/bin

WGET="wget "

if [ ! -d "$GCCC" ] ; then
    if [ ! -f "$GCCC.tar.gz" ] ; then
      $WGET "https://gcc.gnu.org/pub/gcc/releases/$GCCC/$GCCC.tar.xz"
    fi
  echo "Extracting: $GCCC"
  tar -xf "$GCCC".tar.gz
fi

echo "Copyng gcc dependency libs started"

cp -Ru sys-include $PREFIX/$TARGET
if [ "$GCCC" = "gcc-12.1.0" ]; then
   echo "Updating gcc-12.1.0/libgcc/libgcov-driver.c"
   cp build-data/GCC-12.1.0/libgcov-driver.c gcc-12.1.0/libgcc/libgcov-driver.c
fi

ISL=isl-0.16.1 #
GMP=gmp-6.1.0 #
MPC=mpc-1.2.1
MPFR=mpfr-4.1.0

for arg in "$GMP" "$ISL" "$MPC" "$MPFR"
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

if [ -d ./build-gcc ] ; then
 rm -rf ./build-gcc
fi
mkdir build-gcc

echo "Building gcc started"
touch gcc-started

cd build-gcc

# --disable-hosted-libstdcxx - only build freestanding C++ runtime support,
# Symbian only, lol
# see libstdc++-v3/acinclude.m4
../$GCCC/./configure  --target=$TARGET --prefix=$PREFIX $ICONV --without-headers \
	--enable-languages="c,c++,lto" --enable-lto --enable-interwork \
	--enable-long-long --enable-tls --enable-multilib --enable-wchar_t \
	--enable-c99 --with-newlib --with-dwarf2 --with-static-standard-libraries \
	--disable-hosted-libstdcxx --disable-libstdcxx-pch --disable-shared \
	--disable-option-checking --disable-threads --disable-nls \
	--disable-win32-registry --disable-libssp --disable-libquadmath
	# --enable-libssp
	
# base version. Do not use!
# ../gcc-5.2.0/configure  --target=$TARGET --prefix=$PREFIX  --without-headers \
	# --enable-lto --enable-liboffloadmic \
	# --enable-languages="c,c++,lto" --enable-poison-system-directories \
	# --with-newlib --with-sysroot --with-gnu-as --with-gnu-ld --with-dwarf2 \
	# --disable-hosted-libstdcxx --disable-libstdcxx-pch \
	# --disable-option-checking --disable-threads --disable-nls \
	# --disable-win32-registry --disable-libssp --disable-shared \
	# --enable-interwork --enable-tls --enable-multilib  --enable-threads \
	# --enable-wchar_t --enable-extra-sgxxlite-multilibs --enable-c99 \
	# --enable-long-long --enable-liboffloadmic=target

make $MAKEJOBS -k -l6 2> make-gcc.log
# Ugly hack for:
# D:\MinGW\msys\1.0\bin\make.exe: *** couldn't commit memory for cygwin heap, Win32 error 0
# I hope this suffice:-)
if [ "$WINDOWS_HOST" -eq 1 ]; then
	touch first-make-call
	make $MAKEJOBS -k 2>> make-gcc.log
	make $MAKEJOBS -k 2>> make-gcc.log
	make $MAKEJOBS -k 2>> make-gcc.log
	make $MAKEJOBS -k 2>> make-gcc.log
	make $MAKEJOBS -k 2>> make-gcc.log
	make $MAKEJOBS -k 2>> make-gcc.log
	make $MAKEJOBS -k 2>> make-gcc.log
# make -k 2>> make-gcc.log
# make -k 2>> make-gcc.log
fi

# ___________________
# Test 

# TCL_LIBRARY = /usr/opt/tcl
# DEJAGNULIBS = 
# make -k check

make -k install-strip 2> install-gcc.log
# make install-strip-target-libgcc

cd ..

touch gcc-finished
echo "Bulding gcc finished"
# --with-mode=marm --disable-libstdcxx
# make -k check
# make install
# ../gcc-5.2.0/contrib/test_summary >> tests-results.txt

#Windows only
if [ "$WINDOWS_HOST" -eq 1 ]; then
    rundll32 powrprof.dll,SetSuspendState 0,1,0
fi
