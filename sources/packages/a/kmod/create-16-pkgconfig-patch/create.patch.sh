#!/bin/sh

VERSION=16

tar --files-from=file.list -xjvf ../kmod-$VERSION.tar.bz2
mv kmod-$VERSION kmod-$VERSION-orig

cp -rf ./kmod-$VERSION-new ./kmod-$VERSION

diff -b --unified -Nr  kmod-$VERSION-orig  kmod-$VERSION > kmod-$VERSION-pkgconfig.patch

mv kmod-$VERSION-pkgconfig.patch ../patches

rm -rf ./kmod-$VERSION
rm -rf ./kmod-$VERSION-orig
