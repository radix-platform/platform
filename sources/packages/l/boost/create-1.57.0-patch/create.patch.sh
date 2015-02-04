#!/bin/sh

VERSION=1.57.0

tar --files-from=file.list -xjvf ../boost-$VERSION.tar.bz2
mv boost-$VERSION boost-$VERSION-orig

cp -rf ./boost-$VERSION-new ./boost-$VERSION

diff -b --unified -Nr  boost-$VERSION-orig  boost-$VERSION > boost-$VERSION.patch

mv boost-$VERSION.patch ../patches

rm -rf ./boost-$VERSION
rm -rf ./boost-$VERSION-orig
