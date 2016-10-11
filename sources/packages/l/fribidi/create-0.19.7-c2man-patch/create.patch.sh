#!/bin/sh

VERSION=0.19.7

tar --files-from=file.list -xJvf ../fribidi-$VERSION.tar.xz
mv fribidi-$VERSION fribidi-$VERSION-orig

cp -rf ./fribidi-$VERSION-new ./fribidi-$VERSION

diff -b --unified -Nr  fribidi-$VERSION-orig  fribidi-$VERSION > fribidi-$VERSION-c2man.patch

mv fribidi-$VERSION-c2man.patch ../patches

rm -rf ./fribidi-$VERSION
rm -rf ./fribidi-$VERSION-orig
