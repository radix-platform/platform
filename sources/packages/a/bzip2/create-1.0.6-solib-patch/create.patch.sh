#!/bin/sh

VERSION=1.0.6

tar --files-from=file.list -xzvf ../bzip2-$VERSION.tar.gz
mv bzip2-$VERSION bzip2-$VERSION-orig

cp -rf ./bzip2-$VERSION-new ./bzip2-$VERSION

diff -b --unified -Nr  bzip2-$VERSION-orig  bzip2-$VERSION > bzip2-$VERSION-cross.patch

mv bzip2-$VERSION-cross.patch ../patches

rm -rf ./bzip2-$VERSION
rm -rf ./bzip2-$VERSION-orig
