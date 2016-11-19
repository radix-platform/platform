#!/bin/sh

VERSION=10.74.03

tar --files-from=file.list -xjvf ../netpbm-$VERSION.tar.bz2
mv netpbm-$VERSION netpbm-$VERSION-orig

cp -rf ./netpbm-$VERSION-new ./netpbm-$VERSION

diff -b --unified -Nr  netpbm-$VERSION-orig  netpbm-$VERSION > netpbm-$VERSION-no-x11.patch

mv netpbm-$VERSION-no-x11.patch ../patches

rm -rf ./netpbm-$VERSION
rm -rf ./netpbm-$VERSION-orig
