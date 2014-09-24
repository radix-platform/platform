#!/bin/sh

VERSION=3.82

tar --files-from=file.list -xjvf ../make-$VERSION.tar.bz2
mv make-$VERSION make-$VERSION-orig

cp -rf ./make-$VERSION-new ./make-$VERSION

diff -b --unified -Nr  make-$VERSION-orig  make-$VERSION > make-$VERSION.patch

mv make-$VERSION.patch ../patches

rm -rf ./make-$VERSION
rm -rf ./make-$VERSION-orig
