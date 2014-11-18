#!/bin/sh

VERSION=1.8.8

tar --files-from=file.list -xzvf ../dbus-$VERSION.tar.gz
mv dbus-$VERSION dbus-$VERSION-orig

cp -rf ./dbus-$VERSION-new ./dbus-$VERSION

diff -b --unified -Nr  dbus-$VERSION-orig  dbus-$VERSION > dbus-$VERSION.patch

mv dbus-$VERSION.patch ../patches

rm -rf ./dbus-$VERSION
rm -rf ./dbus-$VERSION-orig
