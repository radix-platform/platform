#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../font-micro-misc-$VERSION.tar.bz2
mv font-micro-misc-$VERSION font-micro-misc-$VERSION-orig

cp -rf ./font-micro-misc-$VERSION-new ./font-micro-misc-$VERSION

diff -b --unified -Nr  font-micro-misc-$VERSION-orig  font-micro-misc-$VERSION > font-micro-misc-$VERSION-automake.patch

mv font-micro-misc-$VERSION-automake.patch ../patches

rm -rf ./font-micro-misc-$VERSION
rm -rf ./font-micro-misc-$VERSION-orig
