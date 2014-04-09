#!/bin/sh

VERSION=2.7

tar --files-from=file.list -xJvf ../patch-$VERSION.tar.xz
mv patch-$VERSION patch-$VERSION-orig

cp -rf ./patch-$VERSION-new ./patch-$VERSION

diff -b --unified -Nr  patch-$VERSION-orig  patch-$VERSION > patch-$VERSION.patch

mv patch-$VERSION.patch ../patches

rm -rf ./patch-$VERSION
rm -rf ./patch-$VERSION-orig
