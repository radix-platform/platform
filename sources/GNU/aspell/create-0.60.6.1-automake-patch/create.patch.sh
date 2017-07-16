#!/bin/sh

VERSION=0.60.6.1

tar --files-from=file.list -xzvf ../aspell-$VERSION.tar.gz
mv aspell-$VERSION aspell-$VERSION-orig

cp -rf ./aspell-$VERSION-new ./aspell-$VERSION

diff -b --unified -Nr  aspell-$VERSION-orig  aspell-$VERSION > aspell-$VERSION-automake.patch

mv aspell-$VERSION-automake.patch ../patches

rm -rf ./aspell-$VERSION
rm -rf ./aspell-$VERSION-orig
