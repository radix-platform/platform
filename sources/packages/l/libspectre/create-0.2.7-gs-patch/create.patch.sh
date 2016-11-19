#!/bin/sh

VERSION=0.2.7

tar --files-from=file.list -xzvf ../libspectre-$VERSION.tar.gz
mv libspectre-$VERSION libspectre-$VERSION-orig

cp -rf ./libspectre-$VERSION-new ./libspectre-$VERSION

diff -b --unified -Nr  libspectre-$VERSION-orig  libspectre-$VERSION > libspectre-$VERSION-gs.patch

mv libspectre-$VERSION-gs.patch ../patches

rm -rf ./libspectre-$VERSION
rm -rf ./libspectre-$VERSION-orig
