#!/bin/sh

VERSION=1.36.8

tar --files-from=file.list -xJvf ../pango-$VERSION.tar.xz
mv pango-$VERSION pango-$VERSION-orig

cp -rf ./pango-$VERSION-new ./pango-$VERSION

diff -b --unified -Nr  pango-$VERSION-orig  pango-$VERSION > pango-$VERSION.patch

mv pango-$VERSION.patch ../patches

rm -rf ./pango-$VERSION
rm -rf ./pango-$VERSION-orig
