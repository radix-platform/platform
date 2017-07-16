#!/bin/sh

VERSION=1.1.1

tar --files-from=file.list -xjvf ../xsetroot-$VERSION.tar.bz2
mv xsetroot-$VERSION xsetroot-$VERSION-orig

cp -rf ./xsetroot-$VERSION-new ./xsetroot-$VERSION

diff -b --unified -Nr  xsetroot-$VERSION-orig  xsetroot-$VERSION > xsetroot-$VERSION-automake.patch

mv xsetroot-$VERSION-automake.patch ../patches

rm -rf ./xsetroot-$VERSION
rm -rf ./xsetroot-$VERSION-orig
