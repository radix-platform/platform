#!/bin/sh

VERSION=4.8.16

tar --files-from=file.list -xJvf ../mc-$VERSION.tar.xz
mv mc-$VERSION mc-$VERSION-orig

cp -rf ./mc-$VERSION-new ./mc-$VERSION

diff -b --unified -Nr  mc-$VERSION-orig  mc-$VERSION > mc-$VERSION-syntax-error.patch

mv mc-$VERSION-syntax-error.patch ../patches

rm -rf ./mc-$VERSION
rm -rf ./mc-$VERSION-orig
