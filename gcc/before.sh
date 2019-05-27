#!/bin/bash
set -e

mkdir ~/src && cd ~/src
curl -s https://downloads.sourceforge.net/tcl/tcl8.6.8-src.tar.gz --output tcl8.6.8-src.tar.gz > /dev/null
curl -s https://downloads.sourceforge.net/expect/expect5.45.4.tar.gz --output expect5.45.4.tar.gz > /dev/null
tar -xf tcl8.6.8-src.tar.gz --strip-components=1
tar -xf expect5.45.4.tar.gz

export SRCDIR=`pwd` &&

cd unix &&

./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            $([ $(uname -m) = x86_64 ] && echo --enable-64bit) &&
make &&

sed -e "s#$SRCDIR/unix#/usr/lib#" \
    -e "s#$SRCDIR#/usr/include#"  \
    -i tclConfig.sh               &&

sed -e "s#$SRCDIR/unix/pkgs/tdbc1.0.6#/usr/lib/tdbc1.0.6#" \
    -e "s#$SRCDIR/pkgs/tdbc1.0.6/generic#/usr/include#"    \
    -e "s#$SRCDIR/pkgs/tdbc1.0.6/library#/usr/lib/tcl8.6#" \
    -e "s#$SRCDIR/pkgs/tdbc1.0.6#/usr/include#"            \
    -i pkgs/tdbc1.0.6/tdbcConfig.sh                        &&

sed -e "s#$SRCDIR/unix/pkgs/itcl4.1.1#/usr/lib/itcl4.1.1#" \
    -e "s#$SRCDIR/pkgs/itcl4.1.1/generic#/usr/include#"    \
    -e "s#$SRCDIR/pkgs/itcl4.1.1#/usr/include#"            \
    -i pkgs/itcl4.1.1/itclConfig.sh                        &&

unset SRCDIR

make install &&
make install-private-headers &&
ln -v -sf tclsh8.6 /usr/bin/tclsh
# chmod -v 755 /usr/lib/libtcl8.6.so