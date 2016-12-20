#!/bin/sh

VERSION=2.3.1

tar --files-from=file.list -xjvf ../xf86vidmodeproto-$VERSION.tar.bz2
mv xf86vidmodeproto-$VERSION xf86vidmodeproto-$VERSION-orig

cp -rf ./xf86vidmodeproto-$VERSION-new ./xf86vidmodeproto-$VERSION

diff -b --unified -Nr  xf86vidmodeproto-$VERSION-orig  xf86vidmodeproto-$VERSION > xf86vidmodeproto-$VERSION-automake.patch

mv xf86vidmodeproto-$VERSION-automake.patch ../patches

rm -rf ./xf86vidmodeproto-$VERSION
rm -rf ./xf86vidmodeproto-$VERSION-orig
