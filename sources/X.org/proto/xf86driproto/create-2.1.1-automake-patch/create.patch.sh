#!/bin/sh

VERSION=2.1.1

tar --files-from=file.list -xjvf ../xf86driproto-$VERSION.tar.bz2
mv xf86driproto-$VERSION xf86driproto-$VERSION-orig

cp -rf ./xf86driproto-$VERSION-new ./xf86driproto-$VERSION

diff -b --unified -Nr  xf86driproto-$VERSION-orig  xf86driproto-$VERSION > xf86driproto-$VERSION-automake.patch

mv xf86driproto-$VERSION-automake.patch ../patches

rm -rf ./xf86driproto-$VERSION
rm -rf ./xf86driproto-$VERSION-orig
