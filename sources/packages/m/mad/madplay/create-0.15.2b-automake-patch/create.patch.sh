#!/bin/sh

VERSION=0.15.2b

tar --files-from=file.list -xzvf ../madplay-$VERSION.tar.gz
mv madplay-$VERSION madplay-$VERSION-orig

cp -rf ./madplay-$VERSION-new ./madplay-$VERSION

diff -b --unified -Nr  madplay-$VERSION-orig  madplay-$VERSION > madplay-$VERSION-automake.patch

mv madplay-$VERSION-automake.patch ../patches

rm -rf ./madplay-$VERSION
rm -rf ./madplay-$VERSION-orig
