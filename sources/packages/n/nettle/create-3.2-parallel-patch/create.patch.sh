#!/bin/sh

VERSION=3.2

tar --files-from=file.list -xzvf ../nettle-$VERSION.tar.gz
mv nettle-$VERSION nettle-$VERSION-orig

cp -rf ./nettle-$VERSION-new ./nettle-$VERSION

diff -b --unified -Nr  nettle-$VERSION-orig  nettle-$VERSION > nettle-$VERSION-parallel.patch

mv nettle-$VERSION-parallel.patch ../patches

rm -rf ./nettle-$VERSION
rm -rf ./nettle-$VERSION-orig
