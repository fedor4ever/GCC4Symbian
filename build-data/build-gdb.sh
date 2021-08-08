
export TARGET=arm-none-symbianelf
GCCC=gcc-11.2.0
GDB=gdb-10.2


# Installation folder
export PREFIX=/usr/local/$GCCC
export PATH=$PATH:$PREFIX/bin
unset CFLAGS
export CFLAGS+="-pipe"

MAKEJOBS=-j4
#Windows only
#set SHELL=cmd.exe allow parallel build on windows
if [ -z "${NUMBER_OF_PROCESSORS}" ]; then
    MAKEJOBS=-j"${NUMBER_OF_PROCESSORS}"
	set SHELL=cmd.exe
fi

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
