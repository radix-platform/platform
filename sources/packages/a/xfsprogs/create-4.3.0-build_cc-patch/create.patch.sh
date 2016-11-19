#!/bin/sh

VERSION=4.3.0

tar --files-from=file.list -xzvf ../xfsprogs-$VERSION.tar.gz
mv xfsprogs-$VERSION xfsprogs-$VERSION-orig

cp -rf ./xfsprogs-$VERSION-new ./xfsprogs-$VERSION

diff -b --unified -Nr  xfsprogs-$VERSION-orig  xfsprogs-$VERSION > xfsprogs-$VERSION-build_cc.patch

mv xfsprogs-$VERSION-build_cc.patch ../patches

rm -rf ./xfsprogs-$VERSION
rm -rf ./xfsprogs-$VERSION-orig
