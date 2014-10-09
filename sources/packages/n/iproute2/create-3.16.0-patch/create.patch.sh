#!/bin/sh

VERSION=3.16.0

tar --files-from=file.list -xJvf ../iproute2-$VERSION.tar.xz
mv iproute2-$VERSION iproute2-$VERSION-orig

cp -rf ./iproute2-$VERSION-new ./iproute2-$VERSION

diff -b --unified -Nr  iproute2-$VERSION-orig  iproute2-$VERSION > iproute2-$VERSION.patch

mv iproute2-$VERSION.patch ../patches

rm -rf ./iproute2-$VERSION
rm -rf ./iproute2-$VERSION-orig
