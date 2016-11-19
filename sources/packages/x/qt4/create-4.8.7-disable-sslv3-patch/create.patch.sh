#!/bin/sh

VERSION=4.8.7

tar --files-from=file.list -xzvf ../qt-everywhere-opensource-src-$VERSION.tar.gz
mv qt-everywhere-opensource-src-$VERSION qt-everywhere-opensource-src-$VERSION-orig

cp -rf ./qt-everywhere-opensource-src-$VERSION-new ./qt-everywhere-opensource-src-$VERSION

diff -b --unified -Nr  qt-everywhere-opensource-src-$VERSION-orig  qt-everywhere-opensource-src-$VERSION > qt4-$VERSION-disable-sslv3.patch

mv qt4-$VERSION-disable-sslv3.patch ../patches

rm -rf ./qt-everywhere-opensource-src-$VERSION
rm -rf ./qt-everywhere-opensource-src-$VERSION-orig
