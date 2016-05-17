#!/bin/sh

VERSION=2.6.3

tar --files-from=file.list -xjvf ../freetype-$VERSION.tar.bz2
mv freetype-$VERSION freetype-$VERSION-orig

cp -rf ./freetype-$VERSION-new ./freetype-$VERSION

diff -b --unified -Nr  freetype-$VERSION-orig  freetype-$VERSION > freetype-$VERSION.patch

mv freetype-$VERSION.patch ../patches

rm -rf ./freetype-$VERSION
rm -rf ./freetype-$VERSION-orig
