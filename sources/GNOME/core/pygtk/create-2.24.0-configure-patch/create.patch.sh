#!/bin/sh

VERSION=2.24.0

tar --files-from=file.list -xjvf ../pygtk-$VERSION.tar.bz2
mv pygtk-$VERSION pygtk-$VERSION-orig

cp -rf ./pygtk-$VERSION-new ./pygtk-$VERSION

diff -b --unified -Nr  pygtk-$VERSION-orig  pygtk-$VERSION > pygtk-$VERSION-configure.patch

mv pygtk-$VERSION-configure.patch ../patches

rm -rf ./pygtk-$VERSION
rm -rf ./pygtk-$VERSION-orig
