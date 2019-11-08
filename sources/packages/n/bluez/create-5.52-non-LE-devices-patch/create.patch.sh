#!/bin/sh

VERSION=5.52

tar --files-from=file.list -xJvf ../bluez-$VERSION.tar.xz
mv bluez-$VERSION bluez-$VERSION-orig

cp -rf ./bluez-$VERSION-new ./bluez-$VERSION

diff --unified -Nr  bluez-$VERSION-orig  bluez-$VERSION > bluez-$VERSION-non-LE-devices.patch

mv bluez-$VERSION-non-LE-devices.patch ../patches

rm -rf ./bluez-$VERSION
rm -rf ./bluez-$VERSION-orig
