#!/bin/sh

VERSION=1.1.5

tar --files-from=file.list -xjvf ../mtdev-$VERSION.tar.bz2
mv mtdev-$VERSION mtdev-$VERSION-orig

cp -rf ./mtdev-$VERSION-new ./mtdev-$VERSION

diff -b --unified -Nr  mtdev-$VERSION-orig  mtdev-$VERSION > mtdev-$VERSION-automake.patch

mv mtdev-$VERSION-automake.patch ../patches

rm -rf ./mtdev-$VERSION
rm -rf ./mtdev-$VERSION-orig
