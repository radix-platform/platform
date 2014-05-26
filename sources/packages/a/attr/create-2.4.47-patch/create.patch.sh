#!/bin/sh

VERSION=2.4.47

tar --files-from=file.list -xzvf ../attr-$VERSION.src.tar.gz
mv attr-$VERSION attr-$VERSION-orig

cp -rf ./attr-$VERSION-new ./attr-$VERSION

diff -b --unified -Nr  attr-$VERSION-orig  attr-$VERSION > attr-$VERSION.patch

mv attr-$VERSION.patch ../patches

rm -rf ./attr-$VERSION
rm -rf ./attr-$VERSION-orig
