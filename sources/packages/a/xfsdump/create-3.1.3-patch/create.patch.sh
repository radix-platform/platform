#!/bin/sh

VERSION=3.1.3

tar --files-from=file.list -xzf ../xfsdump-$VERSION.tar.gz
mv xfsdump-$VERSION xfsdump-$VERSION-orig

cp -rf ./xfsdump-$VERSION-new ./xfsdump-$VERSION

diff -b --unified -Nr  xfsdump-$VERSION-orig  xfsdump-$VERSION > xfsdump-$VERSION.patch

mv xfsdump-$VERSION.patch ../patches

rm -rf ./xfsdump-$VERSION
rm -rf ./xfsdump-$VERSION-orig
