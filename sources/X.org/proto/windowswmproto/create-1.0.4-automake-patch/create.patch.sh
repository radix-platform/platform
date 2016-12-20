#!/bin/sh

VERSION=1.0.4

tar --files-from=file.list -xjvf ../windowswmproto-$VERSION.tar.bz2
mv windowswmproto-$VERSION windowswmproto-$VERSION-orig

cp -rf ./windowswmproto-$VERSION-new ./windowswmproto-$VERSION

diff -b --unified -Nr  windowswmproto-$VERSION-orig  windowswmproto-$VERSION > windowswmproto-$VERSION-automake.patch

mv windowswmproto-$VERSION-automake.patch ../patches

rm -rf ./windowswmproto-$VERSION
rm -rf ./windowswmproto-$VERSION-orig
