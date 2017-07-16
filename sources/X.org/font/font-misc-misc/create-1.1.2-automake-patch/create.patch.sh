#!/bin/sh

VERSION=1.1.2

tar --files-from=file.list -xjvf ../font-misc-misc-$VERSION.tar.bz2
mv font-misc-misc-$VERSION font-misc-misc-$VERSION-orig

cp -rf ./font-misc-misc-$VERSION-new ./font-misc-misc-$VERSION

diff -b --unified -Nr  font-misc-misc-$VERSION-orig  font-misc-misc-$VERSION > font-misc-misc-$VERSION-automake.patch

mv font-misc-misc-$VERSION-automake.patch ../patches

rm -rf ./font-misc-misc-$VERSION
rm -rf ./font-misc-misc-$VERSION-orig
