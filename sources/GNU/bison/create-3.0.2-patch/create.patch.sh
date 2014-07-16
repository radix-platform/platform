#!/bin/sh

VERSION=3.0.2

tar --files-from=file.list -xJvf ../bison-$VERSION.tar.xz
mv bison-$VERSION bison-$VERSION-orig

cp -rf ./bison-$VERSION-new ./bison-$VERSION

diff -b --unified -Nr  bison-$VERSION-orig  bison-$VERSION > bison-$VERSION.patch

mv bison-$VERSION.patch ../patches

rm -rf ./bison-$VERSION
rm -rf ./bison-$VERSION-orig
