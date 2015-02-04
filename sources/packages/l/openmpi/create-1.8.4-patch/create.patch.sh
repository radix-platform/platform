#!/bin/sh

VERSION=1.8.4

tar --files-from=file.list -xjvf ../openmpi-$VERSION.tar.bz2
mv openmpi-$VERSION openmpi-$VERSION-orig

cp -rf ./openmpi-$VERSION-new ./openmpi-$VERSION

diff -b --unified -Nr  openmpi-$VERSION-orig  openmpi-$VERSION > openmpi-$VERSION.patch

mv openmpi-$VERSION.patch ../patches

rm -rf ./openmpi-$VERSION
rm -rf ./openmpi-$VERSION-orig
