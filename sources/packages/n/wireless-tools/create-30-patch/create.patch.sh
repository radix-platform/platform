#!/bin/sh

VERSION=30

tar --files-from=file.list -xzvf ../wireless-tools-$VERSION.tar.gz
mv wireless-tools-$VERSION wireless-tools-$VERSION-orig

cp -rf ./wireless-tools-$VERSION-new ./wireless-tools-$VERSION

diff -b --unified -Nr  wireless-tools-$VERSION-orig  wireless-tools-$VERSION > wireless-tools-$VERSION.patch

mv wireless-tools-$VERSION.patch ../patches

rm -rf ./wireless-tools-$VERSION
rm -rf ./wireless-tools-$VERSION-orig
