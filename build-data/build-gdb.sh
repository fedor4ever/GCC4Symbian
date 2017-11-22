
export TARGET=arm-none-symbianelf
GCCC=gcc-5.5.0

MAKEJOBS=--jobs=1

# Installation folder
export PREFIX=/usr/local/$GCCC
export PATH=$PATH:$PREFIX/bin
unset CFLAGS
export CFLAGS+="-pipe"
export GDB=gdb-8.0.1

if [ -d ./build-gdb ] ; then
 rm -rf ./build-gdb
fi
mkdir build-gdb

touch gdb-started
cd build-gdb

../$GDB/configure --target=$TARGET --prefix=$PREFIX --disable-nls --disable-shared

make $MAKEJOBS 2> gdb-log.txt
make install

cd ..
touch gdb-finished
