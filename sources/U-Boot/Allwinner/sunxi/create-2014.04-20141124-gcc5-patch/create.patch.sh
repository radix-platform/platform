#!/bin/sh

VERSION=2014.04-20141124

tar --files-from=file.list -xJvf ../u-boot-sunxi-$VERSION.tar.xz
mv u-boot-sunxi-$VERSION u-boot-sunxi-$VERSION-orig

cp -rf ./u-boot-sunxi-$VERSION-new ./u-boot-sunxi-$VERSION

diff -b --unified -Nr  u-boot-sunxi-$VERSION-orig  u-boot-sunxi-$VERSION > u-boot-sunxi-$VERSION-gcc5.patch

mv u-boot-sunxi-$VERSION-gcc5.patch ../patches

rm -rf ./u-boot-sunxi-$VERSION
rm -rf ./u-boot-sunxi-$VERSION-orig
