#!/bin/sh

VERSION=1.0.6

tar --files-from=file.list -xjvf ../editres-$VERSION.tar.bz2
mv editres-$VERSION editres-$VERSION-orig

cp -rf ./editres-$VERSION-new ./editres-$VERSION

diff -b --unified -Nr  editres-$VERSION-orig  editres-$VERSION > editres-$VERSION-automake.patch

mv editres-$VERSION-automake.patch ../patches

rm -rf ./editres-$VERSION
rm -rf ./editres-$VERSION-orig
