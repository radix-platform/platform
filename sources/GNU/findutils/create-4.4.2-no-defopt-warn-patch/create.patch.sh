#!/bin/sh

VERSION=4.4.2

tar --files-from=file.list -xzvf ../findutils-$VERSION.tar.gz
mv findutils-$VERSION findutils-$VERSION-orig

cp -rf ./findutils-$VERSION-new ./findutils-$VERSION

diff -b --unified -Nr  findutils-$VERSION-orig  findutils-$VERSION > findutils-$VERSION-no-defopt-warn.patch

mv findutils-$VERSION-no-defopt-warn.patch ../patches

rm -rf ./findutils-$VERSION
rm -rf ./findutils-$VERSION-orig
