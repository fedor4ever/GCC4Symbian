
export TARGET=arm-none-symbianelf
GCCC=gcc-6.1.0
# Installation folder
export PREFIX=/usr/local/$GCCC
export PATH=$PATH:$PREFIX/bin
unset CFLAGS
export CFLAGS+="-pipe"
export GDB=gdb-7.11


if [ -d ./build-gdb ] ; then
 rm -rf ./build-gdb
 mkdir build-gdb
else
 mkdir build-gdb
fi

touch gdb-started
cd build-gdb

../$GDB/configure --target=$TARGET --prefix=$PREFIX --disable-nls --disable-shared

make 2> gdb-log.txt
make install-strip

cd ..
touch gdb-finished
