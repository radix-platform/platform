#!/bin/sh

VERSION=4.0.6

tar --files-from=file.list -xzvf ../tiff-$VERSION.tar.gz
mv tiff-$VERSION tiff-$VERSION-orig

cp -rf ./tiff-$VERSION-new ./tiff-$VERSION

diff -b --unified -Nr  tiff-$VERSION-orig  tiff-$VERSION > libtiff-$VERSION-am-version.patch

mv libtiff-$VERSION-am-version.patch ../patches

rm -rf ./tiff-$VERSION
rm -rf ./tiff-$VERSION-orig
