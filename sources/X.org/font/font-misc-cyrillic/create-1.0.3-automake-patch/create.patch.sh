#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../font-misc-cyrillic-$VERSION.tar.bz2
mv font-misc-cyrillic-$VERSION font-misc-cyrillic-$VERSION-orig

cp -rf ./font-misc-cyrillic-$VERSION-new ./font-misc-cyrillic-$VERSION

diff -b --unified -Nr  font-misc-cyrillic-$VERSION-orig  font-misc-cyrillic-$VERSION > font-misc-cyrillic-$VERSION-automake.patch

mv font-misc-cyrillic-$VERSION-automake.patch ../patches

rm -rf ./font-misc-cyrillic-$VERSION
rm -rf ./font-misc-cyrillic-$VERSION-orig
