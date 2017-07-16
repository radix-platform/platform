#!/bin/sh

VERSION=0.106

tar --files-from=file.list -xzvf ../dbus-glib-$VERSION.tar.gz
mv dbus-glib-$VERSION dbus-glib-$VERSION-orig

cp -rf ./dbus-glib-$VERSION-new ./dbus-glib-$VERSION

diff -b --unified -Nr  dbus-glib-$VERSION-orig  dbus-glib-$VERSION > dbus-glib-$VERSION-gtkdoc.patch

mv dbus-glib-$VERSION-gtkdoc.patch ../patches

rm -rf ./dbus-glib-$VERSION
rm -rf ./dbus-glib-$VERSION-orig
