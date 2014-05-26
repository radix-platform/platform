#!/bin/sh

VERSION=2.2.12

tar --files-from=file.list -xzvf ../dmapi-$VERSION.tar.gz
mv dmapi-$VERSION dmapi-$VERSION-orig

cp -rf ./dmapi-$VERSION-new ./dmapi-$VERSION

diff -b --unified -Nr  dmapi-$VERSION-orig  dmapi-$VERSION > dmapi-$VERSION.patch

mv dmapi-$VERSION.patch ../patches

rm -rf ./dmapi-$VERSION
rm -rf ./dmapi-$VERSION-orig
