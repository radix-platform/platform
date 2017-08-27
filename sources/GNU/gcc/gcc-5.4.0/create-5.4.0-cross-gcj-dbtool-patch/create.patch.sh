#!/bin/sh

VERSION=5.4.0

tar --files-from=file.list -xjvf ../gcc-$VERSION.tar.bz2
mv gcc-$VERSION gcc-$VERSION-orig

cp -rf ./gcc-$VERSION-new ./gcc-$VERSION

diff -b --unified -Nr  gcc-$VERSION-orig  gcc-$VERSION > gcc-$VERSION-cross-gcj-dbtool.patch

mv gcc-$VERSION-cross-gcj-dbtool.patch ../patches

rm -rf ./gcc-$VERSION
rm -rf ./gcc-$VERSION-orig