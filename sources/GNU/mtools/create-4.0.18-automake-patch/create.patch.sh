#!/bin/sh

VERSION=4.0.18

tar --files-from=file.list -xjvf ../mtools-$VERSION.tar.bz2
mv mtools-$VERSION mtools-$VERSION-orig

cp -rf ./mtools-$VERSION-new ./mtools-$VERSION

diff -b --unified -Nr  mtools-$VERSION-orig  mtools-$VERSION > mtools-$VERSION-automake.patch

mv mtools-$VERSION-automake.patch ../patches

rm -rf ./mtools-$VERSION
rm -rf ./mtools-$VERSION-orig
