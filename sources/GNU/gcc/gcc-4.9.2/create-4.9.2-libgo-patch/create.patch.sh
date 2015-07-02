#!/bin/sh

VERSION=4.9.2

tar --files-from=file.list -xjvf ../gcc-$VERSION.tar.bz2
mv gcc-$VERSION gcc-$VERSION-orig

cp -rf ./gcc-$VERSION-new ./gcc-$VERSION

diff -b --unified -Nr  gcc-$VERSION-orig  gcc-$VERSION > gcc-$VERSION-libgo.patch

mv gcc-$VERSION-libgo.patch ../patches

rm -rf ./gcc-$VERSION
rm -rf ./gcc-$VERSION-orig
