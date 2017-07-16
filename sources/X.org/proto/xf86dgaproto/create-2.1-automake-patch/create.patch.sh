#!/bin/sh

VERSION=2.1

tar --files-from=file.list -xjvf ../xf86dgaproto-$VERSION.tar.bz2
mv xf86dgaproto-$VERSION xf86dgaproto-$VERSION-orig

cp -rf ./xf86dgaproto-$VERSION-new ./xf86dgaproto-$VERSION

diff -b --unified -Nr  xf86dgaproto-$VERSION-orig  xf86dgaproto-$VERSION > xf86dgaproto-$VERSION-automake.patch

mv xf86dgaproto-$VERSION-automake.patch ../patches

rm -rf ./xf86dgaproto-$VERSION
rm -rf ./xf86dgaproto-$VERSION-orig
