#!/bin/sh

VERSION=20140713

tar --files-from=file.list -xjvf ../u-boot-sunxi-$VERSION.tar.bz2
mv u-boot-sunxi-$VERSION u-boot-sunxi-$VERSION-orig

cp -rf ./u-boot-sunxi-$VERSION-new ./u-boot-sunxi-$VERSION

diff -b --unified -Nr  u-boot-sunxi-$VERSION-orig  u-boot-sunxi-$VERSION > u-boot-sunxi-$VERSION-cb3x-384MHz.patch

mv u-boot-sunxi-$VERSION-cb3x-384MHz.patch ../patches

rm -rf ./u-boot-sunxi-$VERSION
rm -rf ./u-boot-sunxi-$VERSION-orig
