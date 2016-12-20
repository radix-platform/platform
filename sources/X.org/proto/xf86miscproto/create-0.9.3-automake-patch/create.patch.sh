#!/bin/sh

VERSION=0.9.3

tar --files-from=file.list -xjvf ../xf86miscproto-$VERSION.tar.bz2
mv xf86miscproto-$VERSION xf86miscproto-$VERSION-orig

cp -rf ./xf86miscproto-$VERSION-new ./xf86miscproto-$VERSION

diff -b --unified -Nr  xf86miscproto-$VERSION-orig  xf86miscproto-$VERSION > xf86miscproto-$VERSION-automake.patch

mv xf86miscproto-$VERSION-automake.patch ../patches

rm -rf ./xf86miscproto-$VERSION
rm -rf ./xf86miscproto-$VERSION-orig
