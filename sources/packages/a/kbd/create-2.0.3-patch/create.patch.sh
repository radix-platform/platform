#!/bin/sh

VERSION=2.0.3

tar --files-from=file.list -xJvf ../kbd-$VERSION.tar.xz
mv kbd-$VERSION kbd-$VERSION-orig

cp -rf ./kbd-$VERSION-new ./kbd-$VERSION

diff -b --unified -Nr  kbd-$VERSION-orig  kbd-$VERSION > kbd-$VERSION.patch

mv kbd-$VERSION.patch ../patches

rm -rf ./kbd-$VERSION
rm -rf ./kbd-$VERSION-orig
