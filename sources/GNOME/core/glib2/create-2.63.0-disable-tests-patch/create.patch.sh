#!/bin/sh

VERSION=2.63.0

tar --files-from=file.list -xJvf ../glib-$VERSION.tar.xz
mv glib-$VERSION glib-$VERSION-orig

cp -rf ./glib-$VERSION-new ./glib-$VERSION

diff -b --unified -Nr  glib-$VERSION-orig  glib-$VERSION > glib-$VERSION-disable-tests.patch

mv glib-$VERSION-disable-tests.patch ../patches

rm -rf ./glib-$VERSION
rm -rf ./glib-$VERSION-orig
