#!/bin/sh

LOCAL_PATH=`dirname $0`
LOCAL_PATH=`cd $LOCAL_PATH && pwd`
VER=build

[ -d openttd-$VER-$1 ] || mkdir -p openttd-$VER-$1/bin/baseset

export ARCH=$1

CPU_TYPE=32
[ "$ARCH" = "arm64-v8a" ] && CPU_TYPE=64
[ "$ARCH" = "x86_64" ] && CPU_TYPE=64

[ -e openttd-$VER-$1/objs/lang/english.lng ] || {
	sh -c "cd openttd-$VER-$1 && ../src/configure --without-freetype --without-png --without-zlib --without-lzo2 --without-lzma --cpu-type=$CPU_TYPE && make lang && make -C objs/release endian_target.h depend && make -C objs/setting" || exit 1
	rm -f openttd-$VER-$1/Makefile
} || exit 1

[ -e openttd-$VER-$1/Makefile ] || {
	rm -f src/src/rev.cpp
	env PATH=$LOCAL_PATH/..:$PATH \
	env CLANG=1 ../setEnvironment-$1.sh sh -c "cd openttd-$VER-$1 && env ../src/configure --with-sdl --with-freetype --with-png --with-zlib --with-icu --with-libtimidity='pkg-config libtimidity' --with-lzo2=$LOCAL_PATH/../../../obj/local/$ARCH/liblzo2.so --prefix-dir='.' --data-dir='' --without-allegro --with-fontconfig --with-lzma --cpu-type=$CPU_TYPE"
} || exit 1

NCPU=4
uname -s | grep -i "linux" > /dev/null && NCPU=`cat /proc/cpuinfo | grep -c -i processor`

env CLANG=1 ../setEnvironment-$1.sh sh -c "cd openttd-$VER-$1 && make -j$NCPU VERBOSE=1 STRIP='' "' LIBS="-lsdl-1.2 -llzo2 -lpng -ltimidity -lfontconfig -lfreetype -lexpat-sdl -licui18n -liculx -licu-le-hb -lharfbuzz -licuuc -licudata $LDFLAGS"' && cp -f openttd-$VER-$1/objs/release/openttd libapplication-$1.so || exit 1

