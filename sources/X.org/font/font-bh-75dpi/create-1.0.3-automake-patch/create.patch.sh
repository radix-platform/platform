#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../font-bh-75dpi-$VERSION.tar.bz2
mv font-bh-75dpi-$VERSION font-bh-75dpi-$VERSION-orig

cp -rf ./font-bh-75dpi-$VERSION-new ./font-bh-75dpi-$VERSION

diff -b --unified -Nr  font-bh-75dpi-$VERSION-orig  font-bh-75dpi-$VERSION > font-bh-75dpi-$VERSION-automake.patch

mv font-bh-75dpi-$VERSION-automake.patch ../patches

rm -rf ./font-bh-75dpi-$VERSION
rm -rf ./font-bh-75dpi-$VERSION-orig
