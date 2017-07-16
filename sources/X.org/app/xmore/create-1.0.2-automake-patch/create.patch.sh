#!/bin/sh

VERSION=1.0.2

tar --files-from=file.list -xjvf ../xmore-$VERSION.tar.bz2
mv xmore-$VERSION xmore-$VERSION-orig

cp -rf ./xmore-$VERSION-new ./xmore-$VERSION

diff -b --unified -Nr  xmore-$VERSION-orig  xmore-$VERSION > xmore-$VERSION-automake.patch

mv xmore-$VERSION-automake.patch ../patches

rm -rf ./xmore-$VERSION
rm -rf ./xmore-$VERSION-orig
