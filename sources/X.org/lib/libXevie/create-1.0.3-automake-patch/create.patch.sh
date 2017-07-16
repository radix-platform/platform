#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../libXevie-$VERSION.tar.bz2
mv libXevie-$VERSION libXevie-$VERSION-orig

cp -rf ./libXevie-$VERSION-new ./libXevie-$VERSION

diff -b --unified -Nr  libXevie-$VERSION-orig  libXevie-$VERSION > libXevie-$VERSION-automake.patch

mv libXevie-$VERSION-automake.patch ../patches

rm -rf ./libXevie-$VERSION
rm -rf ./libXevie-$VERSION-orig
