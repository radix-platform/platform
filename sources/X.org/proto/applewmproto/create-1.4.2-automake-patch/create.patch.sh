#!/bin/sh

VERSION=1.4.2

tar --files-from=file.list -xjvf ../applewmproto-$VERSION.tar.bz2
mv applewmproto-$VERSION applewmproto-$VERSION-orig

cp -rf ./applewmproto-$VERSION-new ./applewmproto-$VERSION

diff -b --unified -Nr  applewmproto-$VERSION-orig  applewmproto-$VERSION > applewmproto-$VERSION-automake.patch

mv applewmproto-$VERSION-automake.patch ../patches

rm -rf ./applewmproto-$VERSION
rm -rf ./applewmproto-$VERSION-orig
