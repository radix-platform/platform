#!/bin/sh

VERSION=1.2.1

tar --files-from=file.list -xjvf ../mkcomposecache-$VERSION.tar.bz2
mv mkcomposecache-$VERSION mkcomposecache-$VERSION-orig

cp -rf ./mkcomposecache-$VERSION-new ./mkcomposecache-$VERSION

diff -b --unified -Nr  mkcomposecache-$VERSION-orig  mkcomposecache-$VERSION > mkcomposecache-$VERSION-automake.patch

mv mkcomposecache-$VERSION-automake.patch ../patches

rm -rf ./mkcomposecache-$VERSION
rm -rf ./mkcomposecache-$VERSION-orig
