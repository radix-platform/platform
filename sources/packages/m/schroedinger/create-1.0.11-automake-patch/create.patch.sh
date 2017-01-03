#!/bin/sh

VERSION=1.0.11

tar --files-from=file.list -xzvf ../schroedinger-$VERSION.tar.gz
mv schroedinger-$VERSION schroedinger-$VERSION-orig

cp -rf ./schroedinger-$VERSION-new ./schroedinger-$VERSION

diff -b --unified -Nr  schroedinger-$VERSION-orig  schroedinger-$VERSION > schroedinger-$VERSION-automake.patch

mv schroedinger-$VERSION-automake.patch ../patches

rm -rf ./schroedinger-$VERSION
rm -rf ./schroedinger-$VERSION-orig
