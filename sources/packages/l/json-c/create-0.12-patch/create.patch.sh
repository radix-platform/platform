#!/bin/sh

VERSION=0.12

tar --files-from=file.list -xzvf ../json-c-$VERSION.tar.gz
mv json-c-$VERSION json-c-$VERSION-orig

cp -rf ./json-c-$VERSION-new ./json-c-$VERSION

diff -b --unified -Nr  json-c-$VERSION-orig  json-c-$VERSION > json-c-$VERSION.patch

mv json-c-$VERSION.patch ../patches

rm -rf ./json-c-$VERSION
rm -rf ./json-c-$VERSION-orig
