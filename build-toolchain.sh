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
export TARGET=arm-none-symbianelf
GCCC=gcc-6.2.0
BINUTILS=binutils-2.27
GDB=gdb-7.11.1

# --------------------
# Sources to extract
if [ ! -d $BINUTILS ] ; then
  tar -xf $BINUTILS.tar.*
fi
if [ ! -d $GCCC ] ; then
  tar -xf $GCCC.tar.*
fi
if [ ! -d $GDB ] ; then
  tar -xf $GDB.tar.*
fi

# --------------------
# Installation folder
export PREFIX=/usr/local/$GCCC
export PATH=$PATH:$PREFIX/bin
export CONFIGURE=$GCCC/libstdc++-v3/configure
unset CFLAGS
export CFLAGS+="-pipe"

# ------------------
echo "Bulding binutils pass started"

touch first-pass-started
if [ -d ./build-binutils ] ; then
 rm -rf ./build-binutils
 mkdir build-binutils
else
 mkdir build-binutils
fi

cd build-binutils
../$BINUTILS/configure --target=$TARGET --prefix=$PREFIX --disable-option-checking \
--enable-ld --enable-gold --enable-lto --enable-vtable-verify \
--enable-werror=no --without-headers --disable-nls --disable-shared \
--disable-libquadmath --enable-plugins --enable-multilib

make
make install-strip

cd ..
touch first-pass-finished
echo "Bulding binutils pass finished"

echo "Copyng gcc dependency libs started"
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
#cp -u configure -R $GCCC/libstdc++-v3
echo "Copyng gcc dependency libs finished"

# _____________
unset CFLAGS
export CFLAGS+="-pipe"
if [ -d ./build-gcc ] ; then
 rm -rf ./build-gcc
 mkdir build-gcc
else
 mkdir build-gcc
fi

echo "Bulding gcc started"

# patch for the EOF, SEEK_CUR, and SEEK_END integer constants
# because autoconf can't set them
find='as_fn_error "computing EOF failed" "$LINENO" 5'
replace='$as_echo "computing EOF failed" "$LINENO" >\&5'
# echo $replace
sed -i -e 's/'"$find"'/'"$replace"'/g' $CONFIGURE
find='as_fn_error "computing SEEK_CUR failed" "$LINENO" 5'
replace='$as_echo "computing SEEK_CUR failed" "$LINENO" >\&5'
sed -i -e 's/'"$find"'/'"$replace"'/g' $CONFIGURE
find='as_fn_error "computing SEEK_END failed" "$LINENO" 5'
replace='$as_echo "computing SEEK_END failed" "$LINENO" >\&5'
sed -i -e 's/'"$find"'/'"$replace"'/g' $CONFIGURE

# patch for the void, int, short and long
# because autoconf can't set them
find='if ac_fn_c_compute_int "$LINENO" "(long int) (sizeof (void \*))" "ac_cv_sizeof_void_p"        "$ac_includes_default"'
replace='if ac_fn_c_compute_int "$LINENO" "(long int) (sizeof (void \*))" "ac_cv_sizeof_void_p"'
sed -i -e 's/'"$find"'/'"$replace"'/g' $CONFIGURE

find='if ac_fn_c_compute_int "$LINENO" "(long int) (sizeof (long))" "ac_cv_sizeof_long"        "$ac_includes_default"'
replace='if ac_fn_c_compute_int "$LINENO" "(long int) (sizeof (long))" "ac_cv_sizeof_long"'
sed -i -e 's/'"$find"'/'"$replace"'/g' $CONFIGURE

find='if ac_fn_c_compute_int "$LINENO" "(long int) (sizeof (int))" "ac_cv_sizeof_int"        "$ac_includes_default"'
replace='if ac_fn_c_compute_int "$LINENO" "(long int) (sizeof (int))" "ac_cv_sizeof_int"'
sed -i -e 's/'"$find"'/'"$replace"'/g' $CONFIGURE

find='if ac_fn_c_compute_int "$LINENO" "(long int) (sizeof (short))" "ac_cv_sizeof_short"        "$ac_includes_default"'
replace='if ac_fn_c_compute_int "$LINENO" "(long int) (sizeof (short))" "ac_cv_sizeof_short"'
sed -i -e 's/'"$find"'/'"$replace"'/g' $CONFIGURE

find='if ac_fn_c_compute_int "$LINENO" "(long int) (sizeof (char))" "ac_cv_sizeof_char"        "$ac_includes_default"'
replace='if ac_fn_c_compute_int "$LINENO" "(long int) (sizeof (char))" "ac_cv_sizeof_char"'
sed -i -e 's/'"$find"'/'"$replace"'/g' $CONFIGURE

# find=''
# replace=''
# sed -i -e 's/'"$find"'/'"$replace"'/g' $CONFIGURE



touch build-gcc-started
cd build-gcc
../$GCCC/configure  --target=$TARGET --prefix=$PREFIX  --without-headers \
	--enable-languages="c,c++,lto" --enable-poison-system-directories \
	--enable-lto --with-newlib \
	--with-gnu-as --with-gnu-ld --with-dwarf2 \
	--disable-hosted-libstdcxx --disable-libstdcxx-pch \
	--disable-option-checking --disable-threads --disable-nls \
	--disable-win32-registry --disable-libssp --disable-shared \
	--enable-interwork --enable-tls --enable-multilib \
	--enable-wchar_t --enable-extra-sgxxlite-multilibs --enable-c99 \
	--enable-long-long
	# --with-sysroot

# Ugly hack for:
# D:\MinGW\msys\1.0\bin\make.exe: *** couldn't commit memory for cygwin heap, Win32 error 0
# I hope this enough :-)

# use -k because build libstdc++ expectable failes
# but libsupc and other stuff should be installed!

make -k 2> make-gcc.log
touch first-make-call
make -k 2>> make-gcc.log
make -k 2>> make-gcc.log
make -k 2>> make-gcc.log
# make -k 2>> make-gcc.log
# make -k 2>> make-gcc.log
make -k install-strip

cd ..
touch build-gcc-finished
echo "Bulding gcc finished"

touch gdb-started
cd build-gdb

# ______________________

unset CFLAGS
export CFLAGS+="-pipe"
if [ -d ./build-gdb ] ; then
 rm -rf ./build-gdb
 mkdir build-gdb
else
 mkdir build-gdb
fi

../$GDB/configure --target=$TARGET --prefix=$PREFIX --disable-nls --disable-shared
make 2> gdb-log.txt
make install-strip

cd ..
touch gdb-finished

rundll32 powrprof.dll,SetSuspendState 0,1,0
