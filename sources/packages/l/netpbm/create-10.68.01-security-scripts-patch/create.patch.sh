#!/bin/sh

VERSION=10.68.01

tar --files-from=file.list -xjvf ../netpbm-$VERSION.tar.bz2
mv netpbm-$VERSION netpbm-$VERSION-orig

cp -rf ./netpbm-$VERSION-new ./netpbm-$VERSION

diff -b --unified -Nr  netpbm-$VERSION-orig  netpbm-$VERSION > netpbm-$VERSION-security-scripts.patch

mv netpbm-$VERSION-security-scripts.patch ../patches

rm -rf ./netpbm-$VERSION
rm -rf ./netpbm-$VERSION-orig
