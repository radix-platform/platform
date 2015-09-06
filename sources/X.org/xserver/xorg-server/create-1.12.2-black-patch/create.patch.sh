#!/bin/sh

VERSION=1.12.2

tar --files-from=file.list -xjvf ../xorg-server-$VERSION.tar.bz2
mv xorg-server-$VERSION xorg-server-$VERSION-orig

cp -rf ./xorg-server-$VERSION-new ./xorg-server-$VERSION

diff -b --unified -Nr  xorg-server-$VERSION-orig  xorg-server-$VERSION > xorg-server-$VERSION-black.patch

mv xorg-server-$VERSION-black.patch ../patches

rm -rf ./xorg-server-$VERSION
rm -rf ./xorg-server-$VERSION-orig
