#!/bin/sh

VERSION=1.13.12

tar --files-from=file.list -xJvf ../dbus-$VERSION.tar.xz
mv dbus-$VERSION dbus-$VERSION-orig

cp -rf ./dbus-$VERSION-new ./dbus-$VERSION

diff -b --unified -Nr  dbus-$VERSION-orig  dbus-$VERSION > dbus-$VERSION-x11-launch.patch

mv dbus-$VERSION-x11-launch.patch ../patches

rm -rf ./dbus-$VERSION
rm -rf ./dbus-$VERSION-orig
