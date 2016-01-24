#!/bin/sh

VERSION=22

tar --files-from=file.list -xJvf ../kmod-$VERSION.tar.xz
mv kmod-$VERSION kmod-$VERSION-orig

cp -rf ./kmod-$VERSION-new ./kmod-$VERSION

diff -b --unified -Nr  kmod-$VERSION-orig  kmod-$VERSION > kmod-$VERSION-pkgconfig.patch

mv kmod-$VERSION-pkgconfig.patch ../patches

rm -rf ./kmod-$VERSION
rm -rf ./kmod-$VERSION-orig
