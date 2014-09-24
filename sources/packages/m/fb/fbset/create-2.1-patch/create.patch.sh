#!/bin/sh

VERSION=2.1

tar --files-from=file.list -xzvf ../fbset-$VERSION.tar.gz
mv fbset-$VERSION fbset-$VERSION-orig

cp -rf ./fbset-$VERSION-new ./fbset-$VERSION

diff -b --unified -Nr  fbset-$VERSION-orig  fbset-$VERSION > fbset-$VERSION.patch

mv fbset-$VERSION.patch ../patches

rm -rf ./fbset-$VERSION
rm -rf ./fbset-$VERSION-orig
