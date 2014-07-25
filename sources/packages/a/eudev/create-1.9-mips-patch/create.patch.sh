#!/bin/sh

VERSION=1.9

tar --files-from=file.list -xzvf ../eudev-$VERSION.tar.gz
mv eudev-$VERSION eudev-$VERSION-orig

cp -rf ./eudev-$VERSION-new ./eudev-$VERSION

diff -b --unified -Nr  eudev-$VERSION-orig  eudev-$VERSION > eudev-$VERSION-mips.patch

mv eudev-$VERSION-mips.patch ../patches

rm -rf ./eudev-$VERSION
rm -rf ./eudev-$VERSION-orig
