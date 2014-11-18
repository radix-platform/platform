#!/bin/sh

VERSION=1.5

tar --files-from=file.list -xzvf ../bridge-utils-$VERSION.tar.gz
mv bridge-utils-$VERSION bridge-utils-$VERSION-orig

cp -rf ./bridge-utils-$VERSION-new ./bridge-utils-$VERSION

diff -b --unified -Nr  bridge-utils-$VERSION-orig  bridge-utils-$VERSION > bridge-utils-$VERSION-linux-3.8.x.patch

mv bridge-utils-$VERSION-linux-3.8.x.patch ../patches

rm -rf ./bridge-utils-$VERSION
rm -rf ./bridge-utils-$VERSION-orig
