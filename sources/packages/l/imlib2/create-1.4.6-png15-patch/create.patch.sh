#!/bin/sh

VERSION=1.4.6

tar --files-from=file.list -xjvf ../imlib2-$VERSION.tar.bz2
mv imlib2-$VERSION imlib2-$VERSION-orig

cp -rf ./imlib2-$VERSION-new ./imlib2-$VERSION

diff -b --unified -Nr  imlib2-$VERSION-orig  imlib2-$VERSION > imlib2-$VERSION-png15.patch

mv imlib2-$VERSION-png15.patch ../patches

rm -rf ./imlib2-$VERSION
rm -rf ./imlib2-$VERSION-orig
