
export TARGET=arm-none-symbianelf
# Installation folder
export GCCC=GCC-6.1.0
export PREFIX=/usr/local/$GCCC
export PATH=$PATH:$PREFIX/bin
unset CFLAGS
export CFLAGS+="-pipe"

if [ ! -d $GCCC/mpc ] ; then
 cp -Ru mpc-1.0.3 $GCCC/mpc
fi
if [ ! -d $GCCC/isl ] ; then
 cp -Ru isl-0.16.1 $GCCC/isl
fi
if [ ! -d $GCCC/gmp ] ; then
 cp -Ru gmp-6.1.0 $GCCC/gmp
fi
if [ ! -d $GCCC/mpfr ] ; then
 cp -Ru mpfr-3.1.3 $GCCC/mpfr
fi

# cp configure -R $GCCC/libstdc++-v3

if [ -d ./build-gcc ] ; then
 rm -rf ./build-gcc
 mkdir build-gcc
else
 mkdir build-gcc
fi

touch gcc-started

cd build-gcc

../$GCCC/configure  --target=$TARGET --prefix=$PREFIX  --without-headers \
	--enable-languages="c,c++,lto" --enable-poison-system-directories \
	--enable-lto --with-newlib --enable-long-long \
	--with-gnu-as --with-gnu-ld --with-dwarf2 \
	--disable-hosted-libstdcxx --disable-libstdcxx-pch \
	--disable-option-checking --disable-threads --disable-nls \
	--disable-win32-registry --disable-libssp --disable-shared \
	--enable-interwork --enable-tls --enable-multilib \
	--enable-wchar_t --enable-extra-sgxxlite-multilibs --enable-c99

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
# I hope this sufficiently :-)
make -k 2> make-gcc.log
make -k 2>> make-gcc.log
make -k 2>> make-gcc.log
make -k 2>> make-gcc.log
make -k 2>> make-gcc.log
# make -k 2>> make-gcc.log
# make -k | tee make-gcc.log 2>&1
# make -k | tee make-gcc.log 2>&1

# ___________________
# Test 

# TCL_LIBRARY = /usr/opt/tcl
# DEJAGNULIBS = 
# make -k check

# make install-strip 2> install-gcc.log
# make install-strip-target-libgcc
make -k install-strip
# make install-strip | tee install-gcc.log 2>&1

cd ..

touch gcc-finished
# --with-mode=marm --disable-libstdcxx
# make -k check
# make install
# ../gcc-5.2.0/contrib/test_summary >> tests-results.txt

rundll32 powrprof.dll,SetSuspendState 0,1,0
