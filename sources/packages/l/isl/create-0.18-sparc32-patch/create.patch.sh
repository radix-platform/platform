#!/bin/sh

VERSION=0.18

tar --files-from=file.list -xJvf ../isl-$VERSION.tar.xz
mv isl-$VERSION isl-$VERSION-orig

cp -rf ./isl-$VERSION-new ./isl-$VERSION

diff -b --unified -Nr  isl-$VERSION-orig  isl-$VERSION > isl-$VERSION-sparc32.patch

mv isl-$VERSION-sparc32.patch ../patches

rm -rf ./isl-$VERSION
rm -rf ./isl-$VERSION-orig
