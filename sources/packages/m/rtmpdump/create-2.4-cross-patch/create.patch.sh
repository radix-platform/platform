#!/bin/sh

VERSION=2.4

tar --files-from=file.list -xJvf ../rtmpdump-$VERSION.tar.xz
mv rtmpdump-$VERSION rtmpdump-$VERSION-orig

cp -rf ./rtmpdump-$VERSION-new ./rtmpdump-$VERSION

diff -b --unified -Nr  rtmpdump-$VERSION-orig  rtmpdump-$VERSION > rtmpdump-$VERSION-cross.patch

mv rtmpdump-$VERSION-cross.patch ../patches

rm -rf ./rtmpdump-$VERSION
rm -rf ./rtmpdump-$VERSION-orig
