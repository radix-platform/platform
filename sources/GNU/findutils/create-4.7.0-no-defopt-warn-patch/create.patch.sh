#!/bin/sh

VERSION=4.7.0

tar --files-from=file.list -xJvf ../findutils-$VERSION.tar.xz
mv findutils-$VERSION findutils-$VERSION-orig

cp -rf ./findutils-$VERSION-new ./findutils-$VERSION

diff -b --unified -Nr  findutils-$VERSION-orig  findutils-$VERSION > findutils-$VERSION-no-defopt-warn.patch

mv findutils-$VERSION-no-defopt-warn.patch ../patches

rm -rf ./findutils-$VERSION
rm -rf ./findutils-$VERSION-orig
