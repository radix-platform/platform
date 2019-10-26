#!/bin/sh

VERSION=1.4.3

tar --files-from=file.list -xJvf ../zstd-$VERSION.tar.xz
mv zstd-$VERSION zstd-$VERSION-orig

cp -rf ./zstd-$VERSION-new ./zstd-$VERSION

diff -b --unified -Nr  zstd-$VERSION-orig  zstd-$VERSION > zstd-$VERSION-pzstd.patch

mv zstd-$VERSION-pzstd.patch ../patches

rm -rf ./zstd-$VERSION
rm -rf ./zstd-$VERSION-orig
