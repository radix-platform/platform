#!/bin/sh

VERSION=54.1

tar --files-from=file.list -xjvf ../icu4c-$VERSION.tar.bz2
mv icu4c-$VERSION icu4c-$VERSION-orig

cp -rf ./icu4c-$VERSION-new ./icu4c-$VERSION

diff -b --unified -Nr  icu4c-$VERSION-orig  icu4c-$VERSION > icu4c-$VERSION.patch

mv icu4c-$VERSION.patch ../patches

rm -rf ./icu4c-$VERSION
rm -rf ./icu4c-$VERSION-orig
