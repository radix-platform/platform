#!/bin/sh

VERSION=1.3.1

tar --files-from=file.list -xJvf ../flac-$VERSION.tar.xz
mv flac-$VERSION flac-$VERSION-orig

cp -rf ./flac-$VERSION-new ./flac-$VERSION

diff -b --unified -Nr  flac-$VERSION-orig  flac-$VERSION > flac-$VERSION.patch

mv flac-$VERSION.patch ../patches

rm -rf ./flac-$VERSION
rm -rf ./flac-$VERSION-orig
