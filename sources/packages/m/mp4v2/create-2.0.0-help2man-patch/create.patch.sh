#!/bin/sh

VERSION=2.0.0

tar --files-from=file.list -xjvf ../mp4v2-$VERSION.tar.bz2
mv mp4v2-$VERSION mp4v2-$VERSION-orig

cp -rf ./mp4v2-$VERSION-new ./mp4v2-$VERSION

diff -b --unified -Nr  mp4v2-$VERSION-orig  mp4v2-$VERSION > mp4v2-$VERSION-help2man.patch

mv mp4v2-$VERSION-help2man.patch ../patches

rm -rf ./mp4v2-$VERSION
rm -rf ./mp4v2-$VERSION-orig
