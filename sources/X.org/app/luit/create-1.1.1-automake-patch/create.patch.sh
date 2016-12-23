#!/bin/sh

VERSION=1.1.1

tar --files-from=file.list -xjvf ../luit-$VERSION.tar.bz2
mv luit-$VERSION luit-$VERSION-orig

cp -rf ./luit-$VERSION-new ./luit-$VERSION

diff -b --unified -Nr  luit-$VERSION-orig  luit-$VERSION > luit-$VERSION-automake.patch

mv luit-$VERSION-automake.patch ../patches

rm -rf ./luit-$VERSION
rm -rf ./luit-$VERSION-orig
