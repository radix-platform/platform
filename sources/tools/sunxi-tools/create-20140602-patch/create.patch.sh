#!/bin/sh

VERSION=20140602

tar --files-from=file.list -xjvf ../sunxi-tools-$VERSION.tar.bz2
mv sunxi-tools-$VERSION sunxi-tools-$VERSION-orig

cp -rf ./sunxi-tools-$VERSION-new ./sunxi-tools-$VERSION

diff -b --unified -Nr  sunxi-tools-$VERSION-orig  sunxi-tools-$VERSION > sunxi-tools-$VERSION.patch

mv sunxi-tools-$VERSION.patch ../patches

rm -rf ./sunxi-tools-$VERSION
rm -rf ./sunxi-tools-$VERSION-orig
