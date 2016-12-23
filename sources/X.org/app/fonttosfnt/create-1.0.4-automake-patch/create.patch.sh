#!/bin/sh

VERSION=1.0.4

tar --files-from=file.list -xjvf ../fonttosfnt-$VERSION.tar.bz2
mv fonttosfnt-$VERSION fonttosfnt-$VERSION-orig

cp -rf ./fonttosfnt-$VERSION-new ./fonttosfnt-$VERSION

diff -b --unified -Nr  fonttosfnt-$VERSION-orig  fonttosfnt-$VERSION > fonttosfnt-$VERSION-automake.patch

mv fonttosfnt-$VERSION-automake.patch ../patches

rm -rf ./fonttosfnt-$VERSION
rm -rf ./fonttosfnt-$VERSION-orig
