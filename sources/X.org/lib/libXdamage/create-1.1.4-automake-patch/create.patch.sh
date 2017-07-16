#!/bin/sh

VERSION=1.1.4

tar --files-from=file.list -xjvf ../libXdamage-$VERSION.tar.bz2
mv libXdamage-$VERSION libXdamage-$VERSION-orig

cp -rf ./libXdamage-$VERSION-new ./libXdamage-$VERSION

diff -b --unified -Nr  libXdamage-$VERSION-orig  libXdamage-$VERSION > libXdamage-$VERSION-automake.patch

mv libXdamage-$VERSION-automake.patch ../patches

rm -rf ./libXdamage-$VERSION
rm -rf ./libXdamage-$VERSION-orig
