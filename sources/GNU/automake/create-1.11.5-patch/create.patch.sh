#!/bin/sh

VERSION=1.11.5

tar --files-from=file.list -xJvf ../automake-$VERSION.tar.xz
mv automake-$VERSION automake-$VERSION-orig

cp -rf ./automake-$VERSION-new ./automake-$VERSION

diff -b --unified -Nr  automake-$VERSION-orig  automake-$VERSION > automake-$VERSION.patch

mv automake-$VERSION.patch ../patches

rm -rf ./automake-$VERSION
rm -rf ./automake-$VERSION-orig
