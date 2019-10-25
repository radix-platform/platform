#!/bin/sh

VERSION=3.1.8

tar --files-from=file.list -xJvf ../xfsdump-$VERSION.tar.xz
mv xfsdump-$VERSION xfsdump-$VERSION-orig

cp -rf ./xfsdump-$VERSION-new ./xfsdump-$VERSION

diff -b --unified -Nr  xfsdump-$VERSION-orig  xfsdump-$VERSION > xfsdump-$VERSION-xattr.patch

mv xfsdump-$VERSION-xattr.patch ../patches

rm -rf ./xfsdump-$VERSION
rm -rf ./xfsdump-$VERSION-orig
