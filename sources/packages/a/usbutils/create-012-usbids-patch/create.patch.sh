#!/bin/sh

VERSION=012

tar --files-from=file.list -xJvf ../usbutils-$VERSION.tar.xz
mv usbutils-$VERSION usbutils-$VERSION-orig

cp -rf ./usbutils-$VERSION-new ./usbutils-$VERSION

diff -b --unified -Nr  usbutils-$VERSION-orig  usbutils-$VERSION > usbutils-$VERSION-usbids.patch

mv usbutils-$VERSION-usbids.patch ../patches

rm -rf ./usbutils-$VERSION
rm -rf ./usbutils-$VERSION-orig
