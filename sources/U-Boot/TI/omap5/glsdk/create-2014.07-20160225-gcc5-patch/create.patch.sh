#!/bin/sh

VERSION=2014.07-20160225

tar --files-from=file.list -xJvf ../u-boot-omap-$VERSION.tar.xz
mv u-boot-omap-$VERSION u-boot-omap-$VERSION-orig

cp -rf ./u-boot-omap-$VERSION-new ./u-boot-omap-$VERSION

diff -b --unified -Nr  u-boot-omap-$VERSION-orig  u-boot-omap-$VERSION > u-boot-omap-$VERSION-gcc5.patch

mv u-boot-omap-$VERSION-gcc5.patch ../patches

rm -rf ./u-boot-omap-$VERSION
rm -rf ./u-boot-omap-$VERSION-orig
