#!/bin/sh

VERSION=4.2.0

tar --files-from=file.list -xzvf ../qt-creator-opensource-src-$VERSION.tar.gz
mv qt-creator-opensource-src-$VERSION qt-creator-opensource-src-$VERSION-orig

cp -rf ./qt-creator-opensource-src-$VERSION-new ./qt-creator-opensource-src-$VERSION

diff -b --unified -Nr  qt-creator-opensource-src-$VERSION-orig  qt-creator-opensource-src-$VERSION > qt-creator-$VERSION-docs.patch

mv qt-creator-$VERSION-docs.patch ../patches

rm -rf ./qt-creator-opensource-src-$VERSION
rm -rf ./qt-creator-opensource-src-$VERSION-orig
