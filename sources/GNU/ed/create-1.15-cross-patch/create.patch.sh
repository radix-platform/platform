#!/bin/sh

VERSION=1.15

tar --files-from=file.list -xJvf ../ed-$VERSION.tar.xz
mv ed-$VERSION ed-$VERSION-orig

cp -rf ./ed-$VERSION-new ./ed-$VERSION

diff -b --unified -Nr  ed-$VERSION-orig  ed-$VERSION > ed-$VERSION-cross.patch

mv ed-$VERSION-cross.patch ../patches

rm -rf ./ed-$VERSION
rm -rf ./ed-$VERSION-orig
