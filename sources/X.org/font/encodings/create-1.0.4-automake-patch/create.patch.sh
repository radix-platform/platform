#!/bin/sh

VERSION=1.0.4

tar --files-from=file.list -xjvf ../encodings-$VERSION.tar.bz2
mv encodings-$VERSION encodings-$VERSION-orig

cp -rf ./encodings-$VERSION-new ./encodings-$VERSION

diff -b --unified -Nr  encodings-$VERSION-orig  encodings-$VERSION > encodings-$VERSION-automake.patch

mv encodings-$VERSION-automake.patch ../patches

rm -rf ./encodings-$VERSION
rm -rf ./encodings-$VERSION-orig
