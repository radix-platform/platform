#!/bin/sh

VERSION=2015.01-20170224

tar --files-from=file.list -xJvf ../u-boot-aml-$VERSION.tar.xz
mv u-boot-aml-$VERSION u-boot-aml-$VERSION-orig

cp -rf ./u-boot-aml-$VERSION-new ./u-boot-aml-$VERSION

diff -b --unified -Nr  u-boot-aml-$VERSION-orig  u-boot-aml-$VERSION > u-boot-aml-$VERSION-cfgload.patch

mv u-boot-aml-$VERSION-cfgload.patch ../patches

rm -rf ./u-boot-aml-$VERSION
rm -rf ./u-boot-aml-$VERSION-orig
