#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../xvidtune-$VERSION.tar.bz2
mv xvidtune-$VERSION xvidtune-$VERSION-orig

cp -rf ./xvidtune-$VERSION-new ./xvidtune-$VERSION

diff -b --unified -Nr  xvidtune-$VERSION-orig  xvidtune-$VERSION > xvidtune-$VERSION-automake.patch

mv xvidtune-$VERSION-automake.patch ../patches

rm -rf ./xvidtune-$VERSION
rm -rf ./xvidtune-$VERSION-orig
