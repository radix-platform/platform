#!/bin/sh

VERSION=3.2.8

tar --files-from=file.list -xJvf ../eudev-$VERSION.tar.xz
mv eudev-$VERSION eudev-$VERSION-orig

cp -rf ./eudev-$VERSION-new ./eudev-$VERSION

diff -b --unified -Nr  eudev-$VERSION-orig  eudev-$VERSION > eudev-$VERSION-cdrom-id.patch

mv eudev-$VERSION-cdrom-id.patch ../patches

rm -rf ./eudev-$VERSION
rm -rf ./eudev-$VERSION-orig
