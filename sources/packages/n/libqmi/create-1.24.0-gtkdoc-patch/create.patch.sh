#!/bin/sh

VERSION=1.24.0

tar --files-from=file.list -xJvf ../libqmi-$VERSION.tar.xz
mv libqmi-$VERSION libqmi-$VERSION-orig

cp -rf ./libqmi-$VERSION-new ./libqmi-$VERSION

diff -b --unified -Nr  libqmi-$VERSION-orig  libqmi-$VERSION > libqmi-$VERSION-gtkdoc.patch

mv libqmi-$VERSION-gtkdoc.patch ../patches

rm -rf ./libqmi-$VERSION
rm -rf ./libqmi-$VERSION-orig
