#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../listres-$VERSION.tar.bz2
mv listres-$VERSION listres-$VERSION-orig

cp -rf ./listres-$VERSION-new ./listres-$VERSION

diff -b --unified -Nr  listres-$VERSION-orig  listres-$VERSION > listres-$VERSION-automake.patch

mv listres-$VERSION-automake.patch ../patches

rm -rf ./listres-$VERSION
rm -rf ./listres-$VERSION-orig
