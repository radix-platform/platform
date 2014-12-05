#!/bin/sh

VERSION=1.14.0

tar --files-from=file.list -xJvf ../cairo-$VERSION.tar.xz
mv cairo-$VERSION cairo-$VERSION-orig

cp -rf ./cairo-$VERSION-new ./cairo-$VERSION

diff -b --unified -Nr  cairo-$VERSION-orig  cairo-$VERSION > cairo-$VERSION.patch

mv cairo-$VERSION.patch ../patches

rm -rf ./cairo-$VERSION
rm -rf ./cairo-$VERSION-orig
