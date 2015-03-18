#!/bin/sh

VERSION=20140326

tar --files-from=file.list -xjvf ../sunxi-mali-$VERSION.tar.bz2
mv sunxi-mali-$VERSION sunxi-mali-$VERSION-orig

cp -rf ./sunxi-mali-$VERSION-new ./sunxi-mali-$VERSION

diff -b --unified -Nr  sunxi-mali-$VERSION-orig  sunxi-mali-$VERSION > sunxi-mali-$VERSION-no_x11.patch

mv sunxi-mali-$VERSION-no_x11.patch ../patches

rm -rf ./sunxi-mali-$VERSION
rm -rf ./sunxi-mali-$VERSION-orig
