#!/bin/sh

VERSION=1.9.15

tar --files-from=file.list -xjvf ../imlib-$VERSION.tar.bz2
mv imlib-$VERSION imlib-$VERSION-orig

cp -rf ./imlib-$VERSION-new ./imlib-$VERSION

diff -b --unified -Nr  imlib-$VERSION-orig  imlib-$VERSION > imlib-$VERSION-gtk.patch

mv imlib-$VERSION-gtk.patch ../patches

rm -rf ./imlib-$VERSION
rm -rf ./imlib-$VERSION-orig
