#!/bin/sh

VERSION=2.21.2

tar --files-from=file.list -xzvf ../util-linux-$VERSION.tar.gz
mv util-linux-$VERSION util-linux-$VERSION-orig

cp -rf ./util-linux-$VERSION-new ./util-linux-$VERSION

diff -b --unified -Nr  util-linux-$VERSION-orig  util-linux-$VERSION > util-linux-$VERSION.patch

mv util-linux-$VERSION.patch ../patches

rm -rf ./util-linux-$VERSION
rm -rf ./util-linux-$VERSION-orig
