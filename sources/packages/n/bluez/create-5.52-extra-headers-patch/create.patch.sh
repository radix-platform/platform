#!/bin/sh

VERSION=5.52

tar --files-from=file.list -xJvf ../bluez-$VERSION.tar.xz
mv bluez-$VERSION bluez-$VERSION-orig

cp -rf ./bluez-$VERSION-new ./bluez-$VERSION

diff -b --unified -Nr  bluez-$VERSION-orig  bluez-$VERSION > bluez-$VERSION-extra-headers.patch

mv bluez-$VERSION-extra-headers.patch ../patches

rm -rf ./bluez-$VERSION
rm -rf ./bluez-$VERSION-orig
