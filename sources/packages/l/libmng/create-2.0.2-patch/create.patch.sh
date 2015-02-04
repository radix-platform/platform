#!/bin/sh

VERSION=2.0.2

tar --files-from=file.list -xJvf ../libmng-$VERSION.tar.xz
mv libmng-$VERSION libmng-$VERSION-orig

cp -rf ./libmng-$VERSION-new ./libmng-$VERSION

diff -b --unified -Nr  libmng-$VERSION-orig  libmng-$VERSION > libmng-$VERSION.patch

mv libmng-$VERSION.patch ../patches

rm -rf ./libmng-$VERSION
rm -rf ./libmng-$VERSION-orig
