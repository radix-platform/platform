#!/bin/sh

VERSION=2014.10-4.08.84

tar --files-from=file.list -xJvf ../u-boot-baikal-$VERSION.tar.xz
mv u-boot-baikal-$VERSION u-boot-baikal-$VERSION-orig

cp -rf ./u-boot-baikal-$VERSION-new ./u-boot-baikal-$VERSION

diff -b --unified -Nr  u-boot-baikal-$VERSION-orig  u-boot-baikal-$VERSION > u-boot-baikal-$VERSION-dtc.patch

mv u-boot-baikal-$VERSION-dtc.patch ../patches

rm -rf ./u-boot-baikal-$VERSION
rm -rf ./u-boot-baikal-$VERSION-orig
