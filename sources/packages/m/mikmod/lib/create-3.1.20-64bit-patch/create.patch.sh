#!/bin/sh

VERSION=3.1.20

tar --files-from=file.list -xzvf ../libmikmod-$VERSION.tar.gz
mv libmikmod-$VERSION libmikmod-$VERSION-orig

cp -rf ./libmikmod-$VERSION-new ./libmikmod-$VERSION

diff -b --unified -Nr  libmikmod-$VERSION-orig  libmikmod-$VERSION > libmikmod-$VERSION-64bit.patch

mv libmikmod-$VERSION-64bit.patch ../patches

rm -rf ./libmikmod-$VERSION
rm -rf ./libmikmod-$VERSION-orig
