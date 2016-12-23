#!/bin/sh

VERSION=1.1.11

tar --files-from=file.list -xjvf ../xdm-$VERSION.tar.bz2
mv xdm-$VERSION xdm-$VERSION-orig

cp -rf ./xdm-$VERSION-new ./xdm-$VERSION

diff -b --unified -Nr  xdm-$VERSION-orig  xdm-$VERSION > xdm-$VERSION-automake.patch

mv xdm-$VERSION-automake.patch ../patches

rm -rf ./xdm-$VERSION
rm -rf ./xdm-$VERSION-orig
