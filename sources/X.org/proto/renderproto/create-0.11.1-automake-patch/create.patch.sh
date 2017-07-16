#!/bin/sh

VERSION=0.11.1

tar --files-from=file.list -xjvf ../renderproto-$VERSION.tar.bz2
mv renderproto-$VERSION renderproto-$VERSION-orig

cp -rf ./renderproto-$VERSION-new ./renderproto-$VERSION

diff -b --unified -Nr  renderproto-$VERSION-orig  renderproto-$VERSION > renderproto-$VERSION-automake.patch

mv renderproto-$VERSION-automake.patch ../patches

rm -rf ./renderproto-$VERSION
rm -rf ./renderproto-$VERSION-orig
