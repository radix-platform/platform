#!/bin/sh

VERSION=0.22

tar --files-from=file.list -xJvf ../desktop-file-utils-$VERSION.tar.xz
mv desktop-file-utils-$VERSION desktop-file-utils-$VERSION-orig

cp -rf ./desktop-file-utils-$VERSION-new ./desktop-file-utils-$VERSION

diff -b --unified -Nr  desktop-file-utils-$VERSION-orig  desktop-file-utils-$VERSION > desktop-file-utils-$VERSION.patch

mv desktop-file-utils-$VERSION.patch ../patches

rm -rf ./desktop-file-utils-$VERSION
rm -rf ./desktop-file-utils-$VERSION-orig
