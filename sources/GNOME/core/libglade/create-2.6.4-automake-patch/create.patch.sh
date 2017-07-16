#!/bin/sh

VERSION=2.6.4

tar --files-from=file.list -xjvf ../libglade-$VERSION.tar.bz2
mv libglade-$VERSION libglade-$VERSION-orig

cp -rf ./libglade-$VERSION-new ./libglade-$VERSION

diff -b --unified -Nr  libglade-$VERSION-orig  libglade-$VERSION > libglade-$VERSION-automake.patch

mv libglade-$VERSION-automake.patch ../patches

rm -rf ./libglade-$VERSION
rm -rf ./libglade-$VERSION-orig
