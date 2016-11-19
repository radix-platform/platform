#!/bin/sh

VERSION=2.11.95

tar --files-from=file.list -xjvf ../fontconfig-$VERSION.tar.bz2
mv fontconfig-$VERSION fontconfig-$VERSION-orig

cp -rf ./fontconfig-$VERSION-new ./fontconfig-$VERSION

diff -b --unified -Nr  fontconfig-$VERSION-orig  fontconfig-$VERSION > fontconfig-$VERSION.patch

mv fontconfig-$VERSION.patch ../patches

rm -rf ./fontconfig-$VERSION
rm -rf ./fontconfig-$VERSION-orig
