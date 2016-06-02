#!/bin/sh

VERSION=1.4.1

tar --files-from=file.list -xjvf ../xf86-input-aiptek-$VERSION.tar.bz2
mv xf86-input-aiptek-$VERSION xf86-input-aiptek-$VERSION-orig

cp -rf ./xf86-input-aiptek-$VERSION-new ./xf86-input-aiptek-$VERSION

diff -b --unified -Nr  xf86-input-aiptek-$VERSION-orig  xf86-input-aiptek-$VERSION > xf86-input-aiptek-$VERSION-abi.patch

mv xf86-input-aiptek-$VERSION-abi.patch ../patches

rm -rf ./xf86-input-aiptek-$VERSION
rm -rf ./xf86-input-aiptek-$VERSION-orig
