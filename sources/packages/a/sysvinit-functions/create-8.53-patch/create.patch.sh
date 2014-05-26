#!/bin/sh

VERSION=8.53

tar --files-from=file.list -xjvf ../function-src-$VERSION.tar.bz2
mv function-src-$VERSION function-src-$VERSION-orig

cp -rf ./function-src-$VERSION-new ./function-src-$VERSION

diff -b --unified -Nr  function-src-$VERSION-orig  function-src-$VERSION > function-src-$VERSION-make.patch

mv function-src-$VERSION-make.patch ../patches

rm -rf ./function-src-$VERSION
rm -rf ./function-src-$VERSION-orig
