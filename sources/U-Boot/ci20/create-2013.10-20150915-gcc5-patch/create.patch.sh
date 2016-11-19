#!/bin/sh

VERSION=2013.10-20150915

tar --files-from=file.list -xjvf ../u-boot-ci20-$VERSION.tar.bz2
mv u-boot-ci20-$VERSION u-boot-ci20-$VERSION-orig

cp -rf ./u-boot-ci20-$VERSION-new ./u-boot-ci20-$VERSION

diff -b --unified -Nr  u-boot-ci20-$VERSION-orig  u-boot-ci20-$VERSION > u-boot-ci20-$VERSION-gcc5.patch

mv u-boot-ci20-$VERSION-gcc5.patch ../patches

rm -rf ./u-boot-ci20-$VERSION
rm -rf ./u-boot-ci20-$VERSION-orig
