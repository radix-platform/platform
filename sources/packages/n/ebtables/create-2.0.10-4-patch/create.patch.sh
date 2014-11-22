#!/bin/sh

VERSION=2.0.10-4

tar --files-from=file.list -xzvf ../ebtables-$VERSION.tar.gz
mv ebtables-$VERSION ebtables-$VERSION-orig

cp -rf ./ebtables-$VERSION-new ./ebtables-$VERSION

diff -b --unified -Nr  ebtables-$VERSION-orig  ebtables-$VERSION > ebtables-$VERSION.patch

mv ebtables-$VERSION.patch ../patches

rm -rf ./ebtables-$VERSION
rm -rf ./ebtables-$VERSION-orig
