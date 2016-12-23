#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../lbxproxy-$VERSION.tar.bz2
mv lbxproxy-$VERSION lbxproxy-$VERSION-orig

cp -rf ./lbxproxy-$VERSION-new ./lbxproxy-$VERSION

diff -b --unified -Nr  lbxproxy-$VERSION-orig  lbxproxy-$VERSION > lbxproxy-$VERSION-automake.patch

mv lbxproxy-$VERSION-automake.patch ../patches

rm -rf ./lbxproxy-$VERSION
rm -rf ./lbxproxy-$VERSION-orig
