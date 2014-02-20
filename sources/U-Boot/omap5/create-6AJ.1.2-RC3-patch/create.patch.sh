#!/bin/sh

VERSION=6AJ.1.2-RC3

tar --files-from=file.list -xjvf ../u-boot-omap-$VERSION.tar.bz2
mv u-boot-omap-$VERSION u-boot-omap-$VERSION-orig

cp -rf ./u-boot-omap-$VERSION-new ./u-boot-omap-$VERSION

diff -b --unified -Nr  u-boot-omap-$VERSION-orig  u-boot-omap-$VERSION > u-boot-omap-$VERSION.patch

mv u-boot-omap-$VERSION.patch ../patches

rm -rf ./u-boot-omap-$VERSION
rm -rf ./u-boot-omap-$VERSION-orig
