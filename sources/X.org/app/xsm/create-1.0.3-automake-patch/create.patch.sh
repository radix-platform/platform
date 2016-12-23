#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../xsm-$VERSION.tar.bz2
mv xsm-$VERSION xsm-$VERSION-orig

cp -rf ./xsm-$VERSION-new ./xsm-$VERSION

diff -b --unified -Nr  xsm-$VERSION-orig  xsm-$VERSION > xsm-$VERSION-automake.patch

mv xsm-$VERSION-automake.patch ../patches

rm -rf ./xsm-$VERSION
rm -rf ./xsm-$VERSION-orig
