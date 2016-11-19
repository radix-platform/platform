#!/bin/sh

VERSION=1.40.1

tar --files-from=file.list -xJvf ../pango-$VERSION.tar.xz
mv pango-$VERSION pango-$VERSION-orig

cp -rf ./pango-$VERSION-new ./pango-$VERSION

diff -b --unified -Nr  pango-$VERSION-orig  pango-$VERSION > pango-$VERSION-no-eps.patch

mv pango-$VERSION-no-eps.patch ../patches

rm -rf ./pango-$VERSION
rm -rf ./pango-$VERSION-orig
