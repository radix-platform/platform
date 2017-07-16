#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../xstdcmap-$VERSION.tar.bz2
mv xstdcmap-$VERSION xstdcmap-$VERSION-orig

cp -rf ./xstdcmap-$VERSION-new ./xstdcmap-$VERSION

diff -b --unified -Nr  xstdcmap-$VERSION-orig  xstdcmap-$VERSION > xstdcmap-$VERSION-automake.patch

mv xstdcmap-$VERSION-automake.patch ../patches

rm -rf ./xstdcmap-$VERSION
rm -rf ./xstdcmap-$VERSION-orig
