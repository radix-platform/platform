#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../font-sony-misc-$VERSION.tar.bz2
mv font-sony-misc-$VERSION font-sony-misc-$VERSION-orig

cp -rf ./font-sony-misc-$VERSION-new ./font-sony-misc-$VERSION

diff -b --unified -Nr  font-sony-misc-$VERSION-orig  font-sony-misc-$VERSION > font-sony-misc-$VERSION-automake.patch

mv font-sony-misc-$VERSION-automake.patch ../patches

rm -rf ./font-sony-misc-$VERSION
rm -rf ./font-sony-misc-$VERSION-orig
