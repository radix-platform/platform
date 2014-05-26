#!/bin/sh

VERSION=3.1.11

tar --files-from=file.list -xzvf ../xfsprogs-$VERSION.tar.gz
mv xfsprogs-$VERSION xfsprogs-$VERSION-orig

cp -rf ./xfsprogs-$VERSION-new ./xfsprogs-$VERSION

diff -b --unified -Nr  xfsprogs-$VERSION-orig  xfsprogs-$VERSION > xfsprogs-$VERSION.patch

mv xfsprogs-$VERSION.patch ../patches

rm -rf ./xfsprogs-$VERSION
rm -rf ./xfsprogs-$VERSION-orig
