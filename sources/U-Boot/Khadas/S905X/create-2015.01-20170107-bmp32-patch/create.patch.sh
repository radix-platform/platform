#!/bin/sh

VERSION=2015.01-20170107

tar --files-from=file.list -xJvf ../u-boot-khadas-$VERSION.tar.xz
mv u-boot-khadas-$VERSION u-boot-khadas-$VERSION-orig

cp -rf ./u-boot-khadas-$VERSION-new ./u-boot-khadas-$VERSION

diff -b --unified -Nr  u-boot-khadas-$VERSION-orig  u-boot-khadas-$VERSION > u-boot-khadas-$VERSION-bmp32.patch

mv u-boot-khadas-$VERSION-bmp32.patch ../patches

rm -rf ./u-boot-khadas-$VERSION
rm -rf ./u-boot-khadas-$VERSION-orig
