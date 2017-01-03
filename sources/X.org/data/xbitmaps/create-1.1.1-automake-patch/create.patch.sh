#!/bin/sh

VERSION=1.1.1

tar --files-from=file.list -xjvf ../xbitmaps-$VERSION.tar.bz2
mv xbitmaps-$VERSION xbitmaps-$VERSION-orig

cp -rf ./xbitmaps-$VERSION-new ./xbitmaps-$VERSION

diff -b --unified -Nr  xbitmaps-$VERSION-orig  xbitmaps-$VERSION > xbitmaps-$VERSION-automake.patch

mv xbitmaps-$VERSION-automake.patch ../patches

rm -rf ./xbitmaps-$VERSION
rm -rf ./xbitmaps-$VERSION-orig
