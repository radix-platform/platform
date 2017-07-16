#!/bin/sh

VERSION=1.0.4

tar --files-from=file.list -xjvf ../viewres-$VERSION.tar.bz2
mv viewres-$VERSION viewres-$VERSION-orig

cp -rf ./viewres-$VERSION-new ./viewres-$VERSION

diff -b --unified -Nr  viewres-$VERSION-orig  viewres-$VERSION > viewres-$VERSION-automake.patch

mv viewres-$VERSION-automake.patch ../patches

rm -rf ./viewres-$VERSION
rm -rf ./viewres-$VERSION-orig
