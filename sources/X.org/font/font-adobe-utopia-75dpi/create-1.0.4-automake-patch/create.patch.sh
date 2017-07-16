#!/bin/sh

VERSION=1.0.4

tar --files-from=file.list -xjvf ../font-adobe-utopia-75dpi-$VERSION.tar.bz2
mv font-adobe-utopia-75dpi-$VERSION font-adobe-utopia-75dpi-$VERSION-orig

cp -rf ./font-adobe-utopia-75dpi-$VERSION-new ./font-adobe-utopia-75dpi-$VERSION

diff -b --unified -Nr  font-adobe-utopia-75dpi-$VERSION-orig  font-adobe-utopia-75dpi-$VERSION > font-adobe-utopia-75dpi-$VERSION-automake.patch

mv font-adobe-utopia-75dpi-$VERSION-automake.patch ../patches

rm -rf ./font-adobe-utopia-75dpi-$VERSION
rm -rf ./font-adobe-utopia-75dpi-$VERSION-orig
