#!/bin/sh

VERSION=13.0.0

tar --files-from=file.list -xjvf ../xf86-input-vmmouse-$VERSION.tar.bz2
mv xf86-input-vmmouse-$VERSION xf86-input-vmmouse-$VERSION-orig

cp -rf ./xf86-input-vmmouse-$VERSION-new ./xf86-input-vmmouse-$VERSION

diff -b --unified -Nr  xf86-input-vmmouse-$VERSION-orig  xf86-input-vmmouse-$VERSION > xf86-input-vmmouse-$VERSION-xorg.patch

mv xf86-input-vmmouse-$VERSION-xorg.patch ../patches

rm -rf ./xf86-input-vmmouse-$VERSION
rm -rf ./xf86-input-vmmouse-$VERSION-orig
