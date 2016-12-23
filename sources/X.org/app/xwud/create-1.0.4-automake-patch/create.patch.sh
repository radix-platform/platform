#!/bin/sh

VERSION=1.0.4

tar --files-from=file.list -xjvf ../xwud-$VERSION.tar.bz2
mv xwud-$VERSION xwud-$VERSION-orig

cp -rf ./xwud-$VERSION-new ./xwud-$VERSION

diff -b --unified -Nr  xwud-$VERSION-orig  xwud-$VERSION > xwud-$VERSION-automake.patch

mv xwud-$VERSION-automake.patch ../patches

rm -rf ./xwud-$VERSION
rm -rf ./xwud-$VERSION-orig
