#!/bin/sh

VERSION=s20190709

tar --files-from=file.list -xJvf ../iputils-$VERSION.tar.xz
mv iputils-$VERSION iputils-$VERSION-orig

cp -rf ./iputils-$VERSION-new ./iputils-$VERSION

diff -b --unified -Nr  iputils-$VERSION-orig  iputils-$VERSION > iputils-$VERSION-docbook-revert.patch

mv iputils-$VERSION-docbook-revert.patch ../patches

rm -rf ./iputils-$VERSION
rm -rf ./iputils-$VERSION-orig
