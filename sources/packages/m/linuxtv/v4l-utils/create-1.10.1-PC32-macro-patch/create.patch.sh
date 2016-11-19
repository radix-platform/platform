#!/bin/sh

VERSION=1.10.1

tar --files-from=file.list -xjvf ../v4l-utils-$VERSION.tar.bz2
mv v4l-utils-$VERSION v4l-utils-$VERSION-orig

cp -rf ./v4l-utils-$VERSION-new ./v4l-utils-$VERSION

diff -b --unified -Nr  v4l-utils-$VERSION-orig  v4l-utils-$VERSION > v4l-utils-$VERSION-PC32-macro.patch

mv v4l-utils-$VERSION-PC32-macro.patch ../patches

rm -rf ./v4l-utils-$VERSION
rm -rf ./v4l-utils-$VERSION-orig
