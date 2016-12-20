#!/bin/sh

VERSION=2.3.1

tar --files-from=file.list -xjvf ../dmxproto-$VERSION.tar.bz2
mv dmxproto-$VERSION dmxproto-$VERSION-orig

cp -rf ./dmxproto-$VERSION-new ./dmxproto-$VERSION

diff -b --unified -Nr  dmxproto-$VERSION-orig  dmxproto-$VERSION > dmxproto-$VERSION-automake.patch

mv dmxproto-$VERSION-automake.patch ../patches

rm -rf ./dmxproto-$VERSION
rm -rf ./dmxproto-$VERSION-orig
