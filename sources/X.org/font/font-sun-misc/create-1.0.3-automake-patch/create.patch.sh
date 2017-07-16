#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../font-sun-misc-$VERSION.tar.bz2
mv font-sun-misc-$VERSION font-sun-misc-$VERSION-orig

cp -rf ./font-sun-misc-$VERSION-new ./font-sun-misc-$VERSION

diff -b --unified -Nr  font-sun-misc-$VERSION-orig  font-sun-misc-$VERSION > font-sun-misc-$VERSION-automake.patch

mv font-sun-misc-$VERSION-automake.patch ../patches

rm -rf ./font-sun-misc-$VERSION
rm -rf ./font-sun-misc-$VERSION-orig
