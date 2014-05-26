#!/bin/sh

VERSION=1.4.0

tar --files-from=file.list -xJvf ../ziptool-$VERSION.tar.xz
mv ziptool-$VERSION ziptool-$VERSION-orig

cp -rf ./ziptool-$VERSION-new ./ziptool-$VERSION

diff -b --unified -Nr  ziptool-$VERSION-orig  ziptool-$VERSION > ziptool-$VERSION.patch

mv ziptool-$VERSION.patch ../patches

rm -rf ./ziptool-$VERSION
rm -rf ./ziptool-$VERSION-orig
