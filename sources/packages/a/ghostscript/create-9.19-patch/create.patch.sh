#!/bin/sh

VERSION=9.19

tar --files-from=file.list -xzvf ../ghostscript-$VERSION.tar.gz
mv ghostscript-$VERSION ghostscript-$VERSION-orig

cp -rf ./ghostscript-$VERSION-new ./ghostscript-$VERSION

diff -b --unified -Nr  ghostscript-$VERSION-orig  ghostscript-$VERSION > ghostscript-$VERSION.patch

mv ghostscript-$VERSION.patch ../patches

rm -rf ./ghostscript-$VERSION
rm -rf ./ghostscript-$VERSION-orig
