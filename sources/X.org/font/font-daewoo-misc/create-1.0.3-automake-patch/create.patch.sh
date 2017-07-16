#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../font-daewoo-misc-$VERSION.tar.bz2
mv font-daewoo-misc-$VERSION font-daewoo-misc-$VERSION-orig

cp -rf ./font-daewoo-misc-$VERSION-new ./font-daewoo-misc-$VERSION

diff -b --unified -Nr  font-daewoo-misc-$VERSION-orig  font-daewoo-misc-$VERSION > font-daewoo-misc-$VERSION-automake.patch

mv font-daewoo-misc-$VERSION-automake.patch ../patches

rm -rf ./font-daewoo-misc-$VERSION
rm -rf ./font-daewoo-misc-$VERSION-orig
