#!/bin/sh

VERSION=1.14.2

tar --files-from=file.list -xjvf ../recordproto-$VERSION.tar.bz2
mv recordproto-$VERSION recordproto-$VERSION-orig

cp -rf ./recordproto-$VERSION-new ./recordproto-$VERSION

diff -b --unified -Nr  recordproto-$VERSION-orig  recordproto-$VERSION > recordproto-$VERSION-automake.patch

mv recordproto-$VERSION-automake.patch ../patches

rm -rf ./recordproto-$VERSION
rm -rf ./recordproto-$VERSION-orig
