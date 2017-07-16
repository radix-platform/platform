#!/bin/sh

VERSION=3.14.29-20170119

tar --files-from=file.list -xJvf ../linux-aml-$VERSION.tar.xz
mv linux-aml-$VERSION linux-aml-$VERSION-orig

cp -rf ./linux-aml-$VERSION-new ./linux-aml-$VERSION

diff -b --unified -Nr  linux-aml-$VERSION-orig  linux-aml-$VERSION > linux-aml-$VERSION-x2-dts.patch

mv linux-aml-$VERSION-x2-dts.patch ../patches

rm -rf ./linux-aml-$VERSION
rm -rf ./linux-aml-$VERSION-orig
