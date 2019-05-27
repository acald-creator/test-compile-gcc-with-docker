#!/bin/bash
set -e

export PREFIX="/usr/local/cross"
export TARGET=x86_64-pc-linux-gnu
export PATH="$PREFIX/bin:$PATH"

# Install dependencies, make sure we are up to date
apt-get update -y
apt-get install -y libffi-dev libgdbm-dev libgmp-dev libjemalloc-dev libncurses5-dev libncursesw5-dev libreadline6-dev libssl-dev libyaml-dev openssl valgrind zlib1g-dev ccache ruby ruby-dev

mkdir ~/src && cd ~/src
svn co https://svn.ruby-lang.org/repos/ruby/trunk ruby && cd ruby
autoconf
CC=gccgo ./configure --target=$TARGET --prefix="$PREFIX" --with-gmp --with-jemalloc --with-valgrind --enable-shared --enable-debug-debug-env --with-ld=/usr/local/cross/bin/ld
make -j9
make install