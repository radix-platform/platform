#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../font-jis-misc-$VERSION.tar.bz2
mv font-jis-misc-$VERSION font-jis-misc-$VERSION-orig

cp -rf ./font-jis-misc-$VERSION-new ./font-jis-misc-$VERSION

diff -b --unified -Nr  font-jis-misc-$VERSION-orig  font-jis-misc-$VERSION > font-jis-misc-$VERSION-automake.patch

mv font-jis-misc-$VERSION-automake.patch ../patches

rm -rf ./font-jis-misc-$VERSION
rm -rf ./font-jis-misc-$VERSION-orig
