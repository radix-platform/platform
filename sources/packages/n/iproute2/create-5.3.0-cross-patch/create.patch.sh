#!/bin/sh

VERSION=5.3.0

tar --files-from=file.list -xJvf ../iproute2-$VERSION.tar.xz
mv iproute2-$VERSION iproute2-$VERSION-orig

cp -rf ./iproute2-$VERSION-new ./iproute2-$VERSION

diff -b --unified -Nr  iproute2-$VERSION-orig  iproute2-$VERSION > iproute2-$VERSION-cross.patch

mv iproute2-$VERSION-cross.patch ../patches

rm -rf ./iproute2-$VERSION
rm -rf ./iproute2-$VERSION-orig
