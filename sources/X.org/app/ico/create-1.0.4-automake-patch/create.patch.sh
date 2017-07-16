#!/bin/sh

VERSION=1.0.4

tar --files-from=file.list -xjvf ../ico-$VERSION.tar.bz2
mv ico-$VERSION ico-$VERSION-orig

cp -rf ./ico-$VERSION-new ./ico-$VERSION

diff -b --unified -Nr  ico-$VERSION-orig  ico-$VERSION > ico-$VERSION-automake.patch

mv ico-$VERSION-automake.patch ../patches

rm -rf ./ico-$VERSION
rm -rf ./ico-$VERSION-orig
