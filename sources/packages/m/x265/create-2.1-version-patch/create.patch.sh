#!/bin/sh

VERSION=2.1

tar --files-from=file.list -xzvf ../x265-$VERSION.tar.gz
mv x265-$VERSION x265-$VERSION-orig

cp -rf ./x265-$VERSION-new ./x265-$VERSION

diff -b --unified -Nr  x265-$VERSION-orig  x265-$VERSION > x265-$VERSION-version.patch

mv x265-$VERSION-version.patch ../patches

rm -rf ./x265-$VERSION
rm -rf ./x265-$VERSION-orig
