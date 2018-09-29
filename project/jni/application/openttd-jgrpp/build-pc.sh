#!/bin/sh

LOCAL_PATH=`dirname $0`
LOCAL_PATH=`cd $LOCAL_PATH && pwd`

mkdir -p openttd-pc openttd-pc/baseset
cd openttd-pc
[ -e bin/baseset ] || cp -a ../src/bin ./
[ -e bin/fonts ] || cp -a ../data/fonts bin/

export CFLAGS=-O0
export CXXFLAGS=-O0

[ -e Makefile ] || ../src/configure --enable-debug --cpu-type=64 || exit 1
make -j8 VERBOSE=1 || exit 1
cd bin

export LD_LIBRARY_PATH=/usr/local/lib

if [ -z "$1" ]; then
	./openttd -d 2 -r 854x480 -b 16bpp-simple # -g opntitle.sav
else
	#valgrind --track-fds=yes --log-file=valgrind.log --leak-check=full --read-var-info=yes \
	gdb -ex run --args \
	./openttd -d 2 -r 854x480 -b 16bpp-simple # -g opntitle.sav
fi
