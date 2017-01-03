#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../font-adobe-75dpi-$VERSION.tar.bz2
mv font-adobe-75dpi-$VERSION font-adobe-75dpi-$VERSION-orig

cp -rf ./font-adobe-75dpi-$VERSION-new ./font-adobe-75dpi-$VERSION

diff -b --unified -Nr  font-adobe-75dpi-$VERSION-orig  font-adobe-75dpi-$VERSION > font-adobe-75dpi-$VERSION-automake.patch

mv font-adobe-75dpi-$VERSION-automake.patch ../patches

rm -rf ./font-adobe-75dpi-$VERSION
rm -rf ./font-adobe-75dpi-$VERSION-orig
