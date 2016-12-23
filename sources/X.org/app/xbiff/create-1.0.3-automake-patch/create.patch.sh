#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../xbiff-$VERSION.tar.bz2
mv xbiff-$VERSION xbiff-$VERSION-orig

cp -rf ./xbiff-$VERSION-new ./xbiff-$VERSION

diff -b --unified -Nr  xbiff-$VERSION-orig  xbiff-$VERSION > xbiff-$VERSION-automake.patch

mv xbiff-$VERSION-automake.patch ../patches

rm -rf ./xbiff-$VERSION
rm -rf ./xbiff-$VERSION-orig
