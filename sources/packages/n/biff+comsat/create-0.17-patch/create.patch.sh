#!/bin/sh

VERSION=0.17

tar --files-from=file.list -xzf ../biff+comsat-$VERSION.tar.gz
mv biff+comsat-$VERSION biff+comsat-$VERSION-orig

cp -rf ./biff+comsat-$VERSION-new ./biff+comsat-$VERSION

diff -b --unified -Nr  biff+comsat-$VERSION-orig  biff+comsat-$VERSION > biff+comsat-$VERSION.patch

mv biff+comsat-$VERSION.patch ../patches

rm -rf ./biff+comsat-$VERSION
rm -rf ./biff+comsat-$VERSION-orig
