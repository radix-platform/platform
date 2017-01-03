#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../font-cursor-misc-$VERSION.tar.bz2
mv font-cursor-misc-$VERSION font-cursor-misc-$VERSION-orig

cp -rf ./font-cursor-misc-$VERSION-new ./font-cursor-misc-$VERSION

diff -b --unified -Nr  font-cursor-misc-$VERSION-orig  font-cursor-misc-$VERSION > font-cursor-misc-$VERSION-automake.patch

mv font-cursor-misc-$VERSION-automake.patch ../patches

rm -rf ./font-cursor-misc-$VERSION
rm -rf ./font-cursor-misc-$VERSION-orig
