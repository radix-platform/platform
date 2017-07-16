#!/bin/sh

VERSION=3.14.29-20170119

tar --files-from=file.list -xJvf ../linux-aml-$VERSION.tar.xz
mv linux-aml-$VERSION linux-aml-$VERSION-orig

cp -rf ./linux-aml-$VERSION-new ./linux-aml-$VERSION

diff -b --unified -Nr  linux-aml-$VERSION-orig  linux-aml-$VERSION > linux-aml-$VERSION-partitions.patch

mv linux-aml-$VERSION-partitions.patch ../patches

rm -rf ./linux-aml-$VERSION
rm -rf ./linux-aml-$VERSION-orig
