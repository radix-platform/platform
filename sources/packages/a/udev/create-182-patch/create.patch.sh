#!/bin/sh

VERSION=182

tar --files-from=file.list -xJvf ../udev-$VERSION.tar.xz
mv udev-$VERSION udev-$VERSION-orig

cp -rf ./udev-$VERSION-new ./udev-$VERSION

diff -b --unified -Nr  udev-$VERSION-orig  udev-$VERSION > udev-$VERSION.patch

mv udev-$VERSION.patch ../patches

rm -rf ./udev-$VERSION
rm -rf ./udev-$VERSION-orig
