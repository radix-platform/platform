#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../font-misc-ethiopic-$VERSION.tar.bz2
mv font-misc-ethiopic-$VERSION font-misc-ethiopic-$VERSION-orig

cp -rf ./font-misc-ethiopic-$VERSION-new ./font-misc-ethiopic-$VERSION

diff -b --unified -Nr  font-misc-ethiopic-$VERSION-orig  font-misc-ethiopic-$VERSION > font-misc-ethiopic-$VERSION-automake.patch

mv font-misc-ethiopic-$VERSION-automake.patch ../patches

rm -rf ./font-misc-ethiopic-$VERSION
rm -rf ./font-misc-ethiopic-$VERSION-orig
