#!/bin/sh

VERSION=4.8.6

tar --files-from=file.list -xzvf ../qt-everywhere-opensource-src-$VERSION.tar.gz
mv qt-everywhere-opensource-src-$VERSION qt-everywhere-opensource-src-$VERSION-orig

cp -rf ./qt-everywhere-opensource-src-$VERSION-new ./qt-everywhere-opensource-src-$VERSION

diff -b --unified -Nr  qt-everywhere-opensource-src-$VERSION-orig  qt-everywhere-opensource-src-$VERSION > qt4-$VERSION-webkit-NEON-Thumb2.patch

mv qt4-$VERSION-webkit-NEON-Thumb2.patch ../patches

rm -rf ./qt-everywhere-opensource-src-$VERSION
rm -rf ./qt-everywhere-opensource-src-$VERSION-orig
