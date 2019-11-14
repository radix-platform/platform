#!/bin/sh

VERSION=4.14

tar --files-from=file.list -xJvf ../crda-$VERSION.tar.xz
mv crda-$VERSION crda-$VERSION-orig

cp -rf ./crda-$VERSION-new ./crda-$VERSION

diff --unified -Nr  crda-$VERSION-orig  crda-$VERSION > crda-$VERSION-key2pub.patch

mv crda-$VERSION-key2pub.patch ../patches

rm -rf ./crda-$VERSION
rm -rf ./crda-$VERSION-orig
