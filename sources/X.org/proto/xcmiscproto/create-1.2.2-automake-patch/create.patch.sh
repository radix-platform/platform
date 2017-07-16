#!/bin/sh

VERSION=1.2.2

tar --files-from=file.list -xjvf ../xcmiscproto-$VERSION.tar.bz2
mv xcmiscproto-$VERSION xcmiscproto-$VERSION-orig

cp -rf ./xcmiscproto-$VERSION-new ./xcmiscproto-$VERSION

diff -b --unified -Nr  xcmiscproto-$VERSION-orig  xcmiscproto-$VERSION > xcmiscproto-$VERSION-automake.patch

mv xcmiscproto-$VERSION-automake.patch ../patches

rm -rf ./xcmiscproto-$VERSION
rm -rf ./xcmiscproto-$VERSION-orig
