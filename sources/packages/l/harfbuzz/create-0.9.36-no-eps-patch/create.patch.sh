#!/bin/sh

VERSION=0.9.36

tar --files-from=file.list -xjvf ../harfbuzz-$VERSION.tar.bz2
mv harfbuzz-$VERSION harfbuzz-$VERSION-orig

cp -rf ./harfbuzz-$VERSION-new ./harfbuzz-$VERSION

diff -b --unified -Nr  harfbuzz-$VERSION-orig  harfbuzz-$VERSION > harfbuzz-$VERSION-no-eps.patch

mv harfbuzz-$VERSION-no-eps.patch ../patches

rm -rf ./harfbuzz-$VERSION
rm -rf ./harfbuzz-$VERSION-orig
