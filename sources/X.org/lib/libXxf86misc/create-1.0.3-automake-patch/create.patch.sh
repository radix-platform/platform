#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../libXxf86misc-$VERSION.tar.bz2
mv libXxf86misc-$VERSION libXxf86misc-$VERSION-orig

cp -rf ./libXxf86misc-$VERSION-new ./libXxf86misc-$VERSION

diff -b --unified -Nr  libXxf86misc-$VERSION-orig  libXxf86misc-$VERSION > libXxf86misc-$VERSION-automake.patch

mv libXxf86misc-$VERSION-automake.patch ../patches

rm -rf ./libXxf86misc-$VERSION
rm -rf ./libXxf86misc-$VERSION-orig
