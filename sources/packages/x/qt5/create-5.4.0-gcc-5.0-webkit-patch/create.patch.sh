#!/bin/sh

VERSION=5.4.0

tar --files-from=file.list -xJvf ../qt-everywhere-opensource-src-$VERSION.tar.xz
mv qt-everywhere-opensource-src-$VERSION qt-everywhere-opensource-src-$VERSION-orig

cp -rf ./qt-everywhere-opensource-src-$VERSION-new ./qt-everywhere-opensource-src-$VERSION

diff -b --unified -Nr  qt-everywhere-opensource-src-$VERSION-orig  qt-everywhere-opensource-src-$VERSION > qt5-$VERSION-gcc-5.0-webkit.patch

mv qt5-$VERSION-gcc-5.0-webkit.patch ../patches

rm -rf ./qt-everywhere-opensource-src-$VERSION
rm -rf ./qt-everywhere-opensource-src-$VERSION-orig
