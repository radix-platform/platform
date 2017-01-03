#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../font-dec-misc-$VERSION.tar.bz2
mv font-dec-misc-$VERSION font-dec-misc-$VERSION-orig

cp -rf ./font-dec-misc-$VERSION-new ./font-dec-misc-$VERSION

diff -b --unified -Nr  font-dec-misc-$VERSION-orig  font-dec-misc-$VERSION > font-dec-misc-$VERSION-automake.patch

mv font-dec-misc-$VERSION-automake.patch ../patches

rm -rf ./font-dec-misc-$VERSION
rm -rf ./font-dec-misc-$VERSION-orig
