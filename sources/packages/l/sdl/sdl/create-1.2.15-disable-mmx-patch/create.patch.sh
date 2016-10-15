#!/bin/sh

VERSION=1.2.15

tar --files-from=file.list -xzvf ../SDL-$VERSION.tar.gz
mv SDL-$VERSION SDL-$VERSION-orig

cp -rf ./SDL-$VERSION-new ./SDL-$VERSION

diff -b --unified -Nr  SDL-$VERSION-orig  SDL-$VERSION > SDL-$VERSION-disable-mmx.patch

mv SDL-$VERSION-disable-mmx.patch ../patches

rm -rf ./SDL-$VERSION
rm -rf ./SDL-$VERSION-orig
