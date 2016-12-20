#!/bin/sh

VERSION=1.2.0

tar --files-from=file.list -xjvf ../resourceproto-$VERSION.tar.bz2
mv resourceproto-$VERSION resourceproto-$VERSION-orig

cp -rf ./resourceproto-$VERSION-new ./resourceproto-$VERSION

diff -b --unified -Nr  resourceproto-$VERSION-orig  resourceproto-$VERSION > resourceproto-$VERSION-automake.patch

mv resourceproto-$VERSION-automake.patch ../patches

rm -rf ./resourceproto-$VERSION
rm -rf ./resourceproto-$VERSION-orig
