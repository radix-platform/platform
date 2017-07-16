#!/bin/sh

VERSION=2.0.7

tar --files-from=file.list -xzvf ../pth-$VERSION.tar.gz
mv pth-$VERSION pth-$VERSION-orig

cp -rf ./pth-$VERSION-new ./pth-$VERSION

diff -b --unified -Nr  pth-$VERSION-orig  pth-$VERSION > pth-$VERSION-automake.patch

mv pth-$VERSION-automake.patch ../patches

rm -rf ./pth-$VERSION
rm -rf ./pth-$VERSION-orig
