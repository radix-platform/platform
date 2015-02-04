#!/bin/sh

VERSION=0.4.0

tar --files-from=file.list -xjvf ../libvisual-$VERSION.tar.bz2
mv libvisual-$VERSION libvisual-$VERSION-orig

cp -rf ./libvisual-$VERSION-new ./libvisual-$VERSION

diff -b --unified -Nr  libvisual-$VERSION-orig  libvisual-$VERSION > libvisual-$VERSION.patch

mv libvisual-$VERSION.patch ../patches

rm -rf ./libvisual-$VERSION
rm -rf ./libvisual-$VERSION-orig
