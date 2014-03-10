#!/bin/sh

VERSION=1.20.7

tar --files-from=file.list -xjvf ../gpm-$VERSION.tar.bz2
mv gpm-$VERSION gpm-$VERSION-orig

cp -rf ./gpm-$VERSION-new ./gpm-$VERSION

diff -b --unified -Nr  gpm-$VERSION-orig  gpm-$VERSION > gpm-$VERSION.patch

mv gpm-$VERSION.patch ../patches

rm -rf ./gpm-$VERSION
rm -rf ./gpm-$VERSION-orig
