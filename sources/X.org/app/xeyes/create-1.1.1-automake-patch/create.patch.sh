#!/bin/sh

VERSION=1.1.1

tar --files-from=file.list -xjvf ../xeyes-$VERSION.tar.bz2
mv xeyes-$VERSION xeyes-$VERSION-orig

cp -rf ./xeyes-$VERSION-new ./xeyes-$VERSION

diff -b --unified -Nr  xeyes-$VERSION-orig  xeyes-$VERSION > xeyes-$VERSION-automake.patch

mv xeyes-$VERSION-automake.patch ../patches

rm -rf ./xeyes-$VERSION
rm -rf ./xeyes-$VERSION-orig
