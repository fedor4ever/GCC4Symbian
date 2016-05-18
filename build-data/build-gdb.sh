
export TARGET=arm-none-symbianelf
# Installation folder
# export PREFIX=/usr/local/$TARGET
export PREFIX=/usr/local/GCC-5.2.0
export PATH=$PATH:$PREFIX/bin
unset CFLAGS
export CFLAGS+="-pipe"
export GCCC=GCC-5.3.0

GDB=D:\mbuild\src\gdb-7.10

touch gdb-started
cd build-gdb

../$GDB/configure --target=$TARGET --prefix=$PREFIX --disable-nls \
--disable-shared --enable-werror=no

cd ..
touch gdb-finished
