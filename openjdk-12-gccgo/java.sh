#!/bin/bash
set -e

export PREFIX="/usr/local/cross"
export TARGET=x86_64-pc-linux-gnu
export PATH="$PREFIX/bin:$PATH"

# The $PREFIX/bin dir _must_ be in the PATH.
which -- $TARGET-as || echo $TARGET-as is not in the PATH

hg clone http://hg.openjdk.java.net/jdk/jdk12/
cd jdk12
CC=gccgo bash configure --enable-libffi-bundling --enable-sjavac --enable-ccache --with-boot-jdk=../jdk-12-gccgo

