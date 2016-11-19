#!/bin/sh

VERSION=3.23

tar --files-from=file.list -xJvf ../nss-$VERSION.tar.xz
mv nss-$VERSION nss-$VERSION-orig

cp -rf ./nss-$VERSION-new ./nss-$VERSION

diff -b --unified -Nr  nss-$VERSION-orig  nss-$VERSION > nss-$VERSION-build-tree.patch

mv nss-$VERSION-build-tree.patch ../patches

rm -rf ./nss-$VERSION
rm -rf ./nss-$VERSION-orig
