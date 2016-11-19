#!/bin/sh

VERSION=2011.03-20150117

tar --files-from=file.list -xJvf ../u-boot-aml-$VERSION.tar.xz
mv u-boot-aml-$VERSION u-boot-aml-$VERSION-orig

cp -rf ./u-boot-aml-$VERSION-new ./u-boot-aml-$VERSION

diff -b --unified -Nr  u-boot-aml-$VERSION-orig  u-boot-aml-$VERSION > u-boot-aml-$VERSION-m8b_m201-mmcboot.patch

mv u-boot-aml-$VERSION-m8b_m201-mmcboot.patch ../patches

rm -rf ./u-boot-aml-$VERSION
rm -rf ./u-boot-aml-$VERSION-orig
