#!/bin/sh

VERSION=0.1.10

tar --files-from=file.list -xzvf ../gamin-$VERSION.tar.gz
mv gamin-$VERSION gamin-$VERSION-orig

cp -rf ./gamin-$VERSION-new ./gamin-$VERSION

diff -b --unified -Nr  gamin-$VERSION-orig  gamin-$VERSION > gamin-$VERSION.patch

mv gamin-$VERSION.patch ../patches

rm -rf ./gamin-$VERSION
rm -rf ./gamin-$VERSION-orig
