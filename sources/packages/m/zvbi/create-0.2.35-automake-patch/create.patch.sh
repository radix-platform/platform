#!/bin/sh

VERSION=0.2.35

tar --files-from=file.list -xjvf ../zvbi-$VERSION.tar.bz2
mv zvbi-$VERSION zvbi-$VERSION-orig

cp -rf ./zvbi-$VERSION-new ./zvbi-$VERSION

diff -b --unified -Nr  zvbi-$VERSION-orig  zvbi-$VERSION > zvbi-$VERSION-automake.patch

mv zvbi-$VERSION-automake.patch ../patches

rm -rf ./zvbi-$VERSION
rm -rf ./zvbi-$VERSION-orig
