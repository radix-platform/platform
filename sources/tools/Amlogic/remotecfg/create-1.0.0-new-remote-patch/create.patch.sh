#!/bin/sh

VERSION=1.0.0

tar --files-from=file.list -xJvf ../remotecfg-$VERSION.tar.xz
mv remotecfg-$VERSION remotecfg-$VERSION-orig

cp -rf ./remotecfg-$VERSION-new ./remotecfg-$VERSION

diff -b --unified -Nr  remotecfg-$VERSION-orig  remotecfg-$VERSION > remotecfg-$VERSION-new-remote.patch

mv remotecfg-$VERSION-new-remote.patch ../patches

rm -rf ./remotecfg-$VERSION
rm -rf ./remotecfg-$VERSION-orig
