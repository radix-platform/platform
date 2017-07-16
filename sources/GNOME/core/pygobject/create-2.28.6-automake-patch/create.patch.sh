#!/bin/sh

VERSION=2.28.6

tar --files-from=file.list -xJvf ../pygobject-$VERSION.tar.xz
mv pygobject-$VERSION pygobject-$VERSION-orig

cp -rf ./pygobject-$VERSION-new ./pygobject-$VERSION

diff -b --unified -Nr  pygobject-$VERSION-orig  pygobject-$VERSION > pygobject-$VERSION-automake.patch

mv pygobject-$VERSION-automake.patch ../patches

rm -rf ./pygobject-$VERSION
rm -rf ./pygobject-$VERSION-orig
