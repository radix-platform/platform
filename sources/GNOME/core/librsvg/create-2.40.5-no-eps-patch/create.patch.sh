#!/bin/sh

VERSION=2.40.5

tar --files-from=file.list -xJvf ../librsvg-$VERSION.tar.xz
mv librsvg-$VERSION librsvg-$VERSION-orig

cp -rf ./librsvg-$VERSION-new ./librsvg-$VERSION

diff -b --unified -Nr  librsvg-$VERSION-orig  librsvg-$VERSION > librsvg-$VERSION-no-eps.patch

mv librsvg-$VERSION-no-eps.patch ../patches

rm -rf ./librsvg-$VERSION
rm -rf ./librsvg-$VERSION-orig
