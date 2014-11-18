#!/bin/sh

VERSION=3.13

tar --files-from=file.list -xJvf ../crda-$VERSION.tar.xz
mv crda-$VERSION crda-$VERSION-orig

cp -rf ./crda-$VERSION-new ./crda-$VERSION

diff -b --unified -Nr  crda-$VERSION-orig  crda-$VERSION > crda-$VERSION.patch

mv crda-$VERSION.patch ../patches

rm -rf ./crda-$VERSION
rm -rf ./crda-$VERSION-orig
