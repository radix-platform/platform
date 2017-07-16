#!/bin/sh

VERSION=1.0.7

tar --files-from=file.list -xjvf ../mkfontdir-$VERSION.tar.bz2
mv mkfontdir-$VERSION mkfontdir-$VERSION-orig

cp -rf ./mkfontdir-$VERSION-new ./mkfontdir-$VERSION

diff -b --unified -Nr  mkfontdir-$VERSION-orig  mkfontdir-$VERSION > mkfontdir-$VERSION-automake.patch

mv mkfontdir-$VERSION-automake.patch ../patches

rm -rf ./mkfontdir-$VERSION
rm -rf ./mkfontdir-$VERSION-orig
