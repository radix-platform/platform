#!/bin/sh

VERSION=0.4.2

tar --files-from=file.list -xjvf ../compositeproto-$VERSION.tar.bz2
mv compositeproto-$VERSION compositeproto-$VERSION-orig

cp -rf ./compositeproto-$VERSION-new ./compositeproto-$VERSION

diff -b --unified -Nr  compositeproto-$VERSION-orig  compositeproto-$VERSION > compositeproto-$VERSION-automake.patch

mv compositeproto-$VERSION-automake.patch ../patches

rm -rf ./compositeproto-$VERSION
rm -rf ./compositeproto-$VERSION-orig
