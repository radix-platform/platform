#!/bin/sh

VERSION=0.2.11

tar --files-from=file.list -xjvf ../libieee1284-$VERSION.tar.bz2
mv libieee1284-$VERSION libieee1284-$VERSION-orig

cp -rf ./libieee1284-$VERSION-new ./libieee1284-$VERSION

diff -b --unified -Nr  libieee1284-$VERSION-orig  libieee1284-$VERSION > libieee1284-$VERSION-automake.patch

mv libieee1284-$VERSION-automake.patch ../patches

rm -rf ./libieee1284-$VERSION
rm -rf ./libieee1284-$VERSION-orig
