#!/bin/sh

VERSION=2.0.1

tar --files-from=file.list -xjvf ../cups-$VERSION-source.tar.bz2
mv cups-$VERSION cups-$VERSION-orig

cp -rf ./cups-$VERSION-new ./cups-$VERSION

diff -b --unified -Nr  cups-$VERSION-orig  cups-$VERSION > cups-$VERSION.patch

mv cups-$VERSION.patch ../patches

rm -rf ./cups-$VERSION
rm -rf ./cups-$VERSION-orig
