#!/bin/sh

VERSION=5.7.0

tar --files-from=file.list -xJvf ../qt-everywhere-opensource-src-$VERSION.tar.xz
mv qt-everywhere-opensource-src-$VERSION qt-everywhere-opensource-src-$VERSION-orig

cp -rf ./qt-everywhere-opensource-src-$VERSION-new ./qt-everywhere-opensource-src-$VERSION

diff -b --unified -Nr  qt-everywhere-opensource-src-$VERSION-orig  qt-everywhere-opensource-src-$VERSION > qt5-$VERSION-mips32r5.patch

mv qt5-$VERSION-mips32r5.patch ../patches

rm -rf ./qt-everywhere-opensource-src-$VERSION
rm -rf ./qt-everywhere-opensource-src-$VERSION-orig
