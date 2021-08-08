
export TARGET=arm-none-symbianelf
# Installation folder
export GCCC=gcc-11.2.0

# I want have enviroment-free statically linked GCC
ICONV=--with-libiconv-prefix=/usr/local

export PREFIX=/usr/local/$GCCC
export PATH=$PATH:$PREFIX/bin
unset CFLAGS
export CFLAGS+="-pipe -Wl,-Bstatic"

MAKEJOBS=-j4
#Windows only
#set SHELL=cmd.exe allow parallel build on windows
if [ -z "${NUMBER_OF_PROCESSORS}" ]; then
    MAKEJOBS=-j"${NUMBER_OF_PROCESSORS}"
	set SHELL=cmd.exe
fi

echo "Copyng gcc dependency libs started"

GMP=gmp-6.1.0 #
ISL=isl-0.16.1 #
MPC=mpc-1.2.1
MPFR=mpfr-3.1.4
# Strange build error in msys2
# MPC=mpc-1.0.3

for arg in "$GMP" "$ISL" "$MPC" "$MPFR"
do
  dir=`echo "$arg" | grep -Eo '^.{3}[[:alpha:]]?'`
  if [ ! -d $GCCC/$dir ] ; then
    if [ ! -f $arg.tar.* ] ; then
      $WGET https://gcc.gnu.org/pub/gcc/infrastructure/$arg.tar.bz2 https://ftp.gnu.org/gnu/mpc/$arg.tar.gz https://ftp.gnu.org/gnu/mpfr/$arg.tar.bz2
    fi
    tar -xf $arg.tar.*
	cp -Ru $arg $GCCC/$dir
  fi
done

echo "Copyng gcc dependency libs finished"

# cp configure -R $GCCC/libstdc++-v3

if [ -d ./build-gcc ] ; then
 rm -rf ./build-gcc
fi
mkdir build-gcc

echo "Building gcc started"
touch gcc-started

cd build-gcc

../$GCCC/./configure  --target=$TARGET --prefix=$PREFIX  --without-headers \
	--enable-languages="c,c++,lto" --enable-poison-system-directories \
	--enable-lto --with-newlib --enable-long-long $ICONV \
	--with-dwarf2 --enable-interwork --enable-tls --enable-multilib \
	--disable-hosted-libstdcxx --disable-libstdcxx-pch \
	--disable-option-checking --disable-threads --disable-nls \
	--disable-win32-registry --disable-libssp --disable-shared \
	--enable-wchar_t --enable-extra-sgxxlite-multilibs --enable-c99 \
	--with-static-standard-libraries --disable-libstdc__-v3 \
	--disable-libstdcxx --disable-libstdc__
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

# Ugly hack for:
# D:\MinGW\msys\1.0\bin\make.exe: *** couldn't commit memory for cygwin heap, Win32 error 0
# I hope this suffice:-)
make $MAKEJOBS -k 2> make-gcc.log
touch first-make-call
make $MAKEJOBS -k 2>> make-gcc.log
make $MAKEJOBS -k 2>> make-gcc.log
make $MAKEJOBS -k 2>> make-gcc.log
make $MAKEJOBS -k 2>> make-gcc.log
make $MAKEJOBS -k 2>> make-gcc.log
make $MAKEJOBS -k 2>> make-gcc.log
# make -k 2>> make-gcc.log
# make -k 2>> make-gcc.log

# ___________________
# Test 

# TCL_LIBRARY = /usr/opt/tcl
# DEJAGNULIBS = 
# make -k check

make -k install-strip 2> install-gcc.log
# make install-strip-target-libgcc
make -k install-strip
# make install-strip | tee install-gcc.log 2>&1

cd ..

touch gcc-finished
echo "Bulding gcc finished"
# --with-mode=marm --disable-libstdcxx
# make -k check
# make install
# ../gcc-5.2.0/contrib/test_summary >> tests-results.txt

#Windows only
if [ -z "${NUMBER_OF_PROCESSORS}" ]; then
    rundll32 powrprof.dll,SetSuspendState 0,1,0
fi
