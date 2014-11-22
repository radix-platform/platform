#!/bin/sh

VERSION=4.0.3

tar --files-from=file.list -xzvf ../tiff-$VERSION.tar.gz
mv tiff-$VERSION tiff-$VERSION-orig

cp -rf ./tiff-$VERSION-new ./tiff-$VERSION

diff -b --unified -Nr  tiff-$VERSION-orig  tiff-$VERSION > libtiff-$VERSION-jpeg-turbo.patch

mv libtiff-$VERSION-jpeg-turbo.patch ../patches

rm -rf ./tiff-$VERSION
rm -rf ./tiff-$VERSION-orig
