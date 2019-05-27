#!/bin/bash
set -e

# Based on https://wiki.osdev.org/GCC_Cross-Compiler

# install prerequisites
apt-get update
apt-get install -y curl nasm build-essential bison flex libgmp3-dev libmpc-dev libmpfr-dev texinfo subversion git libffi-dev libgdbm-dev libgmp-dev libjemalloc-dev libncurses5-dev libncursesw5-dev libreadline6-dev libssl-dev libyaml-dev openssl valgrind zlib1g-dev ccache ruby ruby-dev

# download and extract sources
mkdir ~/src && cd ~/src
curl -s https://ftp.gnu.org/gnu/binutils/binutils-2.32.tar.gz --output binutils-2.32.tar.gz > /dev/null
curl -s https://ftp.gnu.org/gnu/gcc/gcc-9.1.0/gcc-9.1.0.tar.gz --output gcc-9.1.0.tar.gz > /dev/null
tar -xf binutils-2.32.tar.gz
tar -xf gcc-9.1.0.tar.gz

# export variables
export PREFIX="/usr/local/cross"
export TARGET=x86_64-pc-linux-gnu
export PATH="$PREFIX/bin:$PATH"

# build binutils 
cd ~/src

mkdir build-binutils
cd build-binutils
../binutils-2.32/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror --enable-gold=default
make -j9
make install

# build gcc
cd ~/src

# The $PREFIX/bin dir _must_ be in the PATH.
which -- $TARGET-as || echo $TARGET-as is not in the PATH
 
mkdir build-gcc
cd build-gcc
../gcc-9.1.0/configure --target=$TARGET \
 --prefix="$PREFIX" \
 --disable-nls \
 --enable-languages=c,c++,fortran,d \
 --disable-multilib \
 --enable-valgrind-annotations \
 --enable-threads=posix \
 --enable-bootstrap \
 --enable-default-pie \
 --prefix=/tools \
 --libdir=/tools/lib \
 --libexecdir=/tools/lib \
 --with-newlib \
 --with-target-system-zlib \
 --without-headers \
 --with-local-prefix=/tools \
 --with-native-system-header-dir=/tools/include \
 --disable-shared \
 --disable-threads \
 --disable-libmudflap \
 --disable-libquadmath \
 --disable-libssp \
 --disable-libitm \
 --disable-libgomp \
 --disable-decimal-float \
 --disable-libstdc++-v3 \
 --disable-libatomic \
 --disable-libsanitizer \
 --without-ppl \
 --without-cloog \
 --with-tune-generic \
 --disable-libmpx \
 --with-ld=/usr/local/cross/bin/ld

make all-gcc -j9
make all-target-libgcc -j9
make install-gcc
make install-target-libgcc


# cleanup
rm -r ~/src

# Test the new installation
$TARGET-gcc --version