#!/bin/sh

VERSION=4.7.0

tar --files-from=file.list -xzvf ../xfsprogs-$VERSION.tar.gz
mv xfsprogs-$VERSION xfsprogs-$VERSION-orig

cp -rf ./xfsprogs-$VERSION-new ./xfsprogs-$VERSION

diff -b --unified -Nr  xfsprogs-$VERSION-orig  xfsprogs-$VERSION > xfsprogs-$VERSION-loff_t.patch

mv xfsprogs-$VERSION-loff_t.patch ../patches

rm -rf ./xfsprogs-$VERSION
rm -rf ./xfsprogs-$VERSION-orig
