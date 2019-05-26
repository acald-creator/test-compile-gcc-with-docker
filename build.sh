#!/bin/bash
set -e

# Based on https://wiki.osdev.org/GCC_Cross-Compiler

# install prerequisites
# apt-get update
# apt-get install -y curl nasm build-essential bison flex libgmp3-dev libmpc-dev libmpfr-dev texinfo subversion git

# download and extract sources
# mkdir ~/src && cd ~/src
# curl -s https://ftp.gnu.org/gnu/binutils/binutils-2.32.tar.gz --output binutils-2.32.tar.gz > /dev/null
# tar -xf binutils-2.32.tar.gz

# export variables

# build binutils 
# cd ~/src

# mkdir build-binutils
# cd build-binutils
# ../binutils-2.32/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror --enable-gold=default
# make
# make install

# build gcc
cd ~/src

# The $PREFIX/bin dir _must_ be in the PATH.
which -- $TARGET-as || echo $TARGET-as is not in the PATH

export PREFIX="/usr/local/cross"
export TARGET=x86_64-pc-linux-gnu
export PATH="$PREFIX/bin:$PATH"

svn checkout svn://gcc.gnu.org/svn/gcc/branches/gccgo gccgo
cd gccgo
./contrib/download_prerequisites
mkdir build-gccgo
cd build-gccgo
../configure --target=$TARGET --prefix="$PREFIX" --enable-languages=c,c++,go --disable-multilib --with-ld=/usr/local/cross/bin/ld
make all-gcc 
make all-target-libgcc
make install-gcc
make install-target-libgcc

# cleanup
rm -r ~/src

# Test the new installation
$TARGET-gccgo --version