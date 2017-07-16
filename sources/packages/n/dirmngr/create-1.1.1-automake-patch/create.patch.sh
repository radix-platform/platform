#!/bin/sh

VERSION=1.1.1

tar --files-from=file.list -xjvf ../dirmngr-$VERSION.tar.bz2
mv dirmngr-$VERSION dirmngr-$VERSION-orig

cp -rf ./dirmngr-$VERSION-new ./dirmngr-$VERSION

diff -b --unified -Nr  dirmngr-$VERSION-orig  dirmngr-$VERSION > dirmngr-$VERSION-automake.patch

mv dirmngr-$VERSION-automake.patch ../patches

rm -rf ./dirmngr-$VERSION
rm -rf ./dirmngr-$VERSION-orig
