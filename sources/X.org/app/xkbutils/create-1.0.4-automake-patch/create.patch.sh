#!/bin/sh

VERSION=1.0.4

tar --files-from=file.list -xjvf ../xkbutils-$VERSION.tar.bz2
mv xkbutils-$VERSION xkbutils-$VERSION-orig

cp -rf ./xkbutils-$VERSION-new ./xkbutils-$VERSION

diff -b --unified -Nr  xkbutils-$VERSION-orig  xkbutils-$VERSION > xkbutils-$VERSION-automake.patch

mv xkbutils-$VERSION-automake.patch ../patches

rm -rf ./xkbutils-$VERSION
rm -rf ./xkbutils-$VERSION-orig
