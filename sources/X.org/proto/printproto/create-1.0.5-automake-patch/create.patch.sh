#!/bin/sh

VERSION=1.0.5

tar --files-from=file.list -xjvf ../printproto-$VERSION.tar.bz2
mv printproto-$VERSION printproto-$VERSION-orig

cp -rf ./printproto-$VERSION-new ./printproto-$VERSION

diff -b --unified -Nr  printproto-$VERSION-orig  printproto-$VERSION > printproto-$VERSION-automake.patch

mv printproto-$VERSION-automake.patch ../patches

rm -rf ./printproto-$VERSION
rm -rf ./printproto-$VERSION-orig
