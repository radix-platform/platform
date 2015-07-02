#!/bin/sh

VERSION=6.0.0

tar --files-from=file.list -xjvf ../gmp-${VERSION}a.tar.bz2
mv gmp-$VERSION gmp-$VERSION-orig

cp -rf ./gmp-$VERSION-new ./gmp-$VERSION

diff -b --unified -Nr  gmp-$VERSION-orig  gmp-$VERSION > gmp-$VERSION-arm-conditionalise-not-thumb.patch

mv gmp-$VERSION-arm-conditionalise-not-thumb.patch ../patches

rm -rf ./gmp-$VERSION
rm -rf ./gmp-$VERSION-orig
