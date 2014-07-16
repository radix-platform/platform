#!/bin/sh

VERSION=4.2.1

tar --files-from=file.list -xJvf ../shadow-$VERSION.tar.xz
mv shadow-$VERSION shadow-$VERSION-orig

cp -rf ./shadow-$VERSION-new ./shadow-$VERSION

diff -b --unified -Nr  shadow-$VERSION-orig  shadow-$VERSION > shadow-$VERSION.patch

mv shadow-$VERSION.patch ../patches

rm -rf ./shadow-$VERSION
rm -rf ./shadow-$VERSION-orig
