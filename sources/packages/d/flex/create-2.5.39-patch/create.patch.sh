#!/bin/sh

VERSION=2.5.39

tar --files-from=file.list -xJvf ../flex-$VERSION.tar.xz
mv flex-$VERSION flex-$VERSION-orig

cp -rf ./flex-$VERSION-new ./flex-$VERSION

diff -b --unified -Nr  flex-$VERSION-orig  flex-$VERSION > flex-$VERSION.patch

mv flex-$VERSION.patch ../patches

rm -rf ./flex-$VERSION
rm -rf ./flex-$VERSION-orig
