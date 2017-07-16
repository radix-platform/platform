#!/bin/sh

VERSION=230

tar --files-from=file.list -xJvf ../libgudev-$VERSION.tar.xz
mv libgudev-$VERSION libgudev-$VERSION-orig

cp -rf ./libgudev-$VERSION-new ./libgudev-$VERSION

diff -b --unified -Nr  libgudev-$VERSION-orig  libgudev-$VERSION > libgudev-$VERSION-gtkdoc.patch

mv libgudev-$VERSION-gtkdoc.patch ../patches

rm -rf ./libgudev-$VERSION
rm -rf ./libgudev-$VERSION-orig
