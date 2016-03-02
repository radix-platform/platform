#!/bin/sh

VERSION=s20151218

tar --files-from=file.list -xjvf ../iputils-$VERSION.tar.bz2
mv iputils-$VERSION iputils-$VERSION-orig

cp -rf ./iputils-$VERSION-new ./iputils-$VERSION

diff -b --unified -Nr  iputils-$VERSION-orig  iputils-$VERSION > iputils-$VERSION.patch

mv iputils-$VERSION.patch ../patches

rm -rf ./iputils-$VERSION
rm -rf ./iputils-$VERSION-orig
