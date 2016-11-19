#!/bin/sh

VERSION=2.02.141

tar --files-from=file.list -xJvf ../LVM2-$VERSION.tar.xz
mv LVM2-$VERSION LVM2-$VERSION-orig

cp -rf ./LVM2-$VERSION-new ./LVM2-$VERSION

diff -b --unified -Nr  LVM2-$VERSION-orig  LVM2-$VERSION > LVM2-$VERSION-sockets-static.patch

mv LVM2-$VERSION-sockets-static.patch ../patches

rm -rf ./LVM2-$VERSION
rm -rf ./LVM2-$VERSION-orig
