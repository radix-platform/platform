#!/bin/sh

VERSION=6.5.0

tar --files-from=file.list -xJvf ../gcc-$VERSION.tar.xz
mv gcc-$VERSION gcc-$VERSION-orig

cp -rf ./gcc-$VERSION-new ./gcc-$VERSION

diff -b --unified -Nr  gcc-$VERSION-orig  gcc-$VERSION > gcc-$VERSION-libjava-exception.patch

mv gcc-$VERSION-libjava-exception.patch ../patches

rm -rf ./gcc-$VERSION
rm -rf ./gcc-$VERSION-orig
