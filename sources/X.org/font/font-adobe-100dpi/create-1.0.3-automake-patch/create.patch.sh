#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../font-adobe-100dpi-$VERSION.tar.bz2
mv font-adobe-100dpi-$VERSION font-adobe-100dpi-$VERSION-orig

cp -rf ./font-adobe-100dpi-$VERSION-new ./font-adobe-100dpi-$VERSION

diff -b --unified -Nr  font-adobe-100dpi-$VERSION-orig  font-adobe-100dpi-$VERSION > font-adobe-100dpi-$VERSION-automake.patch

mv font-adobe-100dpi-$VERSION-automake.patch ../patches

rm -rf ./font-adobe-100dpi-$VERSION
rm -rf ./font-adobe-100dpi-$VERSION-orig
