#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../font-cronyx-cyrillic-$VERSION.tar.bz2
mv font-cronyx-cyrillic-$VERSION font-cronyx-cyrillic-$VERSION-orig

cp -rf ./font-cronyx-cyrillic-$VERSION-new ./font-cronyx-cyrillic-$VERSION

diff -b --unified -Nr  font-cronyx-cyrillic-$VERSION-orig  font-cronyx-cyrillic-$VERSION > font-cronyx-cyrillic-$VERSION-automake.patch

mv font-cronyx-cyrillic-$VERSION-automake.patch ../patches

rm -rf ./font-cronyx-cyrillic-$VERSION
rm -rf ./font-cronyx-cyrillic-$VERSION-orig
