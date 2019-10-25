#!/bin/sh

VERSION=5.2.1

tar --files-from=file.list -xJvf ../xfsprogs-$VERSION.tar.xz
mv xfsprogs-$VERSION xfsprogs-$VERSION-orig

cp -rf ./xfsprogs-$VERSION-new ./xfsprogs-$VERSION

diff -b --unified -Nr  xfsprogs-$VERSION-orig  xfsprogs-$VERSION > xfsprogs-$VERSION.patch

mv xfsprogs-$VERSION.patch ../patches

rm -rf ./xfsprogs-$VERSION
rm -rf ./xfsprogs-$VERSION-orig
