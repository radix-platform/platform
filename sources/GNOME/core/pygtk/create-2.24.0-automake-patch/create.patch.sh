#!/bin/sh

VERSION=2.24.0

tar --files-from=file.list -xjvf ../pygtk-$VERSION.tar.bz2
mv pygtk-$VERSION pygtk-$VERSION-orig

cp -rf ./pygtk-$VERSION-new ./pygtk-$VERSION

diff -b --unified -Nr  pygtk-$VERSION-orig  pygtk-$VERSION > pygtk-$VERSION-automake.patch

mv pygtk-$VERSION-automake.patch ../patches

rm -rf ./pygtk-$VERSION
rm -rf ./pygtk-$VERSION-orig
