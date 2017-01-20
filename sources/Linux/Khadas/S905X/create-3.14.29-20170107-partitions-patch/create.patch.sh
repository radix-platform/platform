#!/bin/sh

VERSION=3.14.29-20170107

tar --files-from=file.list -xJvf ../linux-khadas-$VERSION.tar.xz
mv linux-khadas-$VERSION linux-khadas-$VERSION-orig

cp -rf ./linux-khadas-$VERSION-new ./linux-khadas-$VERSION

diff -b --unified -Nr  linux-khadas-$VERSION-orig  linux-khadas-$VERSION > linux-khadas-$VERSION-partitions.patch

mv linux-khadas-$VERSION-partitions.patch ../patches

rm -rf ./linux-khadas-$VERSION
rm -rf ./linux-khadas-$VERSION-orig
