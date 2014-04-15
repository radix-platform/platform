#!/bin/sh

VERSION=0.17

tar --files-from=file.list -xzf ../bsd-finger-$VERSION.tar.gz
mv bsd-finger-$VERSION bsd-finger-$VERSION-orig

cp -rf ./bsd-finger-$VERSION-new ./bsd-finger-$VERSION

diff -b --unified -Nr  bsd-finger-$VERSION-orig  bsd-finger-$VERSION > bsd-finger-$VERSION.patch

mv bsd-finger-$VERSION.patch ../patches

rm -rf ./bsd-finger-$VERSION
rm -rf ./bsd-finger-$VERSION-orig
