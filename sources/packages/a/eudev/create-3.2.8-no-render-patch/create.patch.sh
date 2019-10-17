#!/bin/sh

VERSION=3.2.8

tar --files-from=file.list -xJvf ../eudev-$VERSION.tar.xz
mv eudev-$VERSION eudev-$VERSION-orig

cp -rf ./eudev-$VERSION-new ./eudev-$VERSION

diff -b --unified -Nr  eudev-$VERSION-orig  eudev-$VERSION > eudev-$VERSION-no-render.patch

mv eudev-$VERSION-no-render.patch ../patches

rm -rf ./eudev-$VERSION
rm -rf ./eudev-$VERSION-orig
