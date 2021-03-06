#!/bin/sh

VERSION=2.12.2

tar --files-from=file.list -xjvf ../glade-$VERSION.tar.bz2
mv glade-$VERSION glade-$VERSION-orig

cp -rf ./glade-$VERSION-new ./glade-$VERSION

diff -Nur  glade-$VERSION-orig  glade-$VERSION > glade-$VERSION-posix.patch

mv glade-$VERSION-posix.patch ../patches

rm -rf ./glade-$VERSION
rm -rf ./glade-$VERSION-orig
