#!/bin/sh

VERSION=1.9.15

tar --files-from=file.list -xjvf ../imlib-$VERSION.tar.bz2
mv imlib-$VERSION imlib-$VERSION-orig

cp -rf ./imlib-$VERSION-new ./imlib-$VERSION

diff -b --unified -Nr  imlib-$VERSION-orig  imlib-$VERSION > imlib-$VERSION-gif.patch

mv imlib-$VERSION-gif.patch ../patches

rm -rf ./imlib-$VERSION
rm -rf ./imlib-$VERSION-orig
