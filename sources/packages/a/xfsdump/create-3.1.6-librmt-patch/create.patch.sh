#!/bin/sh

VERSION=3.1.6

tar --files-from=file.list -xzvf ../xfsdump-$VERSION.tar.gz
mv xfsdump-$VERSION xfsdump-$VERSION-orig

cp -rf ./xfsdump-$VERSION-new ./xfsdump-$VERSION

diff -b --unified -Nr  xfsdump-$VERSION-orig  xfsdump-$VERSION > xfsdump-$VERSION-librmt.patch

mv xfsdump-$VERSION-librmt.patch ../patches

rm -rf ./xfsdump-$VERSION
rm -rf ./xfsdump-$VERSION-orig
