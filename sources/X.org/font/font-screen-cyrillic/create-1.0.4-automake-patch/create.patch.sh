#!/bin/sh

VERSION=1.0.4

tar --files-from=file.list -xjvf ../font-screen-cyrillic-$VERSION.tar.bz2
mv font-screen-cyrillic-$VERSION font-screen-cyrillic-$VERSION-orig

cp -rf ./font-screen-cyrillic-$VERSION-new ./font-screen-cyrillic-$VERSION

diff -b --unified -Nr  font-screen-cyrillic-$VERSION-orig  font-screen-cyrillic-$VERSION > font-screen-cyrillic-$VERSION-automake.patch

mv font-screen-cyrillic-$VERSION-automake.patch ../patches

rm -rf ./font-screen-cyrillic-$VERSION
rm -rf ./font-screen-cyrillic-$VERSION-orig
