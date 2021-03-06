#!/bin/sh

VERSION=3.10.33-20150117

tar --files-from=file.list -xJvf ../linux-aml-$VERSION.tar.xz
mv linux-aml-$VERSION linux-aml-$VERSION-orig

cp -rf ./linux-aml-$VERSION-new ./linux-aml-$VERSION

diff -b --unified -Nr  linux-aml-$VERSION-orig  linux-aml-$VERSION > linux-aml-$VERSION-m201-dtbs.patch

mv linux-aml-$VERSION-m201-dtbs.patch ../patches

rm -rf ./linux-aml-$VERSION
rm -rf ./linux-aml-$VERSION-orig
