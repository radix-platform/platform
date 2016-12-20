#!/bin/sh

VERSION=7.3.0

tar --files-from=file.list -xjvf ../xextproto-$VERSION.tar.bz2
mv xextproto-$VERSION xextproto-$VERSION-orig

cp -rf ./xextproto-$VERSION-new ./xextproto-$VERSION

diff -b --unified -Nr  xextproto-$VERSION-orig  xextproto-$VERSION > xextproto-$VERSION-automake.patch

mv xextproto-$VERSION-automake.patch ../patches

rm -rf ./xextproto-$VERSION
rm -rf ./xextproto-$VERSION-orig
