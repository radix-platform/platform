#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../oclock-$VERSION.tar.bz2
mv oclock-$VERSION oclock-$VERSION-orig

cp -rf ./oclock-$VERSION-new ./oclock-$VERSION

diff -b --unified -Nr  oclock-$VERSION-orig  oclock-$VERSION > oclock-$VERSION-automake.patch

mv oclock-$VERSION-automake.patch ../patches

rm -rf ./oclock-$VERSION
rm -rf ./oclock-$VERSION-orig
