#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../font-bh-100dpi-$VERSION.tar.bz2
mv font-bh-100dpi-$VERSION font-bh-100dpi-$VERSION-orig

cp -rf ./font-bh-100dpi-$VERSION-new ./font-bh-100dpi-$VERSION

diff -b --unified -Nr  font-bh-100dpi-$VERSION-orig  font-bh-100dpi-$VERSION > font-bh-100dpi-$VERSION-automake.patch

mv font-bh-100dpi-$VERSION-automake.patch ../patches

rm -rf ./font-bh-100dpi-$VERSION
rm -rf ./font-bh-100dpi-$VERSION-orig
