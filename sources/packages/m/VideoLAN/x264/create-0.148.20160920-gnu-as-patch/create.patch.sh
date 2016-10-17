#!/bin/sh

VERSION=0.148.20160920

tar --files-from=file.list -xJvf ../x264-$VERSION.tar.xz
mv x264-$VERSION x264-$VERSION-orig

cp -rf ./x264-$VERSION-new ./x264-$VERSION

diff -b --unified -Nr  x264-$VERSION-orig  x264-$VERSION > x264-$VERSION-gnu-as.patch

mv x264-$VERSION-gnu-as.patch ../patches

rm -rf ./x264-$VERSION
rm -rf ./x264-$VERSION-orig
