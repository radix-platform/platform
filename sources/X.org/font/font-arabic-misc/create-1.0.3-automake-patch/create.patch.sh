#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../font-arabic-misc-$VERSION.tar.bz2
mv font-arabic-misc-$VERSION font-arabic-misc-$VERSION-orig

cp -rf ./font-arabic-misc-$VERSION-new ./font-arabic-misc-$VERSION

diff -b --unified -Nr  font-arabic-misc-$VERSION-orig  font-arabic-misc-$VERSION > font-arabic-misc-$VERSION-automake.patch

mv font-arabic-misc-$VERSION-automake.patch ../patches

rm -rf ./font-arabic-misc-$VERSION
rm -rf ./font-arabic-misc-$VERSION-orig
