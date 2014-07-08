#!/bin/sh

VERSION=1.9

tar --files-from=file.list -xzvf ../ed-$VERSION.tar.gz
mv ed-$VERSION ed-$VERSION-orig

cp -rf ./ed-$VERSION-new ./ed-$VERSION

diff -b --unified -Nr  ed-$VERSION-orig  ed-$VERSION > ed-$VERSION.patch

mv ed-$VERSION.patch ../patches

rm -rf ./ed-$VERSION
rm -rf ./ed-$VERSION-orig
