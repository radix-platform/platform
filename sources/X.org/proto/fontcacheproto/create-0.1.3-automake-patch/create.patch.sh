#!/bin/sh

VERSION=0.1.3

tar --files-from=file.list -xjvf ../fontcacheproto-$VERSION.tar.bz2
mv fontcacheproto-$VERSION fontcacheproto-$VERSION-orig

cp -rf ./fontcacheproto-$VERSION-new ./fontcacheproto-$VERSION

diff -b --unified -Nr  fontcacheproto-$VERSION-orig  fontcacheproto-$VERSION > fontcacheproto-$VERSION-automake.patch

mv fontcacheproto-$VERSION-automake.patch ../patches

rm -rf ./fontcacheproto-$VERSION
rm -rf ./fontcacheproto-$VERSION-orig
