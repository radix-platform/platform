#!/bin/sh

VERSION=5.42

tar --files-from=file.list -xJvf ../bluez-$VERSION.tar.xz
mv bluez-$VERSION bluez-$VERSION-orig

cp -rf ./bluez-$VERSION-new ./bluez-$VERSION

diff -b --unified -Nr  bluez-$VERSION-orig  bluez-$VERSION > bluez-$VERSION-obex-rem-systemd.patch

mv bluez-$VERSION-obex-rem-systemd.patch ../patches

rm -rf ./bluez-$VERSION
rm -rf ./bluez-$VERSION-orig
