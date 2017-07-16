#!/bin/sh

VERSION=1.5.0

tar --files-from=file.list -xjvf ../xf86-input-acecad-$VERSION.tar.bz2
mv xf86-input-acecad-$VERSION xf86-input-acecad-$VERSION-orig

cp -rf ./xf86-input-acecad-$VERSION-new ./xf86-input-acecad-$VERSION

diff -b --unified -Nr  xf86-input-acecad-$VERSION-orig  xf86-input-acecad-$VERSION > xf86-input-acecad-$VERSION-automake.patch

mv xf86-input-acecad-$VERSION-automake.patch ../patches

rm -rf ./xf86-input-acecad-$VERSION
rm -rf ./xf86-input-acecad-$VERSION-orig
