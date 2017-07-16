#!/bin/sh

VERSION=0.5.3

tar --files-from=file.list -xjvf ../libXcm-$VERSION.tar.bz2
mv libXcm-$VERSION libXcm-$VERSION-orig

cp -rf ./libXcm-$VERSION-new ./libXcm-$VERSION

diff -b --unified -Nr  libXcm-$VERSION-orig  libXcm-$VERSION > libXcm-$VERSION-automake.patch

mv libXcm-$VERSION-automake.patch ../patches

rm -rf ./libXcm-$VERSION
rm -rf ./libXcm-$VERSION-orig
