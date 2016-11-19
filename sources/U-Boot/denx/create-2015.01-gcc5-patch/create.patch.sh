#!/bin/sh

VERSION=2015.01

tar --files-from=file.list -xjvf ../u-boot-$VERSION.tar.bz2
mv u-boot-$VERSION u-boot-$VERSION-orig

cp -rf ./u-boot-$VERSION-new ./u-boot-$VERSION

diff -b --unified -Nr  u-boot-$VERSION-orig  u-boot-$VERSION > u-boot-$VERSION-gcc5.patch

mv u-boot-$VERSION-gcc5.patch ../patches

rm -rf ./u-boot-$VERSION
rm -rf ./u-boot-$VERSION-orig
