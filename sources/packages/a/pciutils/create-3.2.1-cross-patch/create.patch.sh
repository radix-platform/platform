#!/bin/sh

VERSION=3.2.1

tar --files-from=file.list -xJf ../pciutils-$VERSION.tar.xz
mv pciutils-$VERSION pciutils-$VERSION-orig

cp -rf ./pciutils-$VERSION-new ./pciutils-$VERSION

diff -b --unified -Nr  pciutils-$VERSION-orig  pciutils-$VERSION > pciutils-$VERSION-cross.patch

mv pciutils-$VERSION-cross.patch ../patches

rm -rf ./pciutils-$VERSION
rm -rf ./pciutils-$VERSION-orig
