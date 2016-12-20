#!/bin/sh

VERSION=1.1.2

tar --files-from=file.list -xjvf ../bigreqsproto-$VERSION.tar.bz2
mv bigreqsproto-$VERSION bigreqsproto-$VERSION-orig

cp -rf ./bigreqsproto-$VERSION-new ./bigreqsproto-$VERSION

diff -b --unified -Nr  bigreqsproto-$VERSION-orig  bigreqsproto-$VERSION > bigreqsproto-$VERSION-automake.patch

mv bigreqsproto-$VERSION-automake.patch ../patches

rm -rf ./bigreqsproto-$VERSION
rm -rf ./bigreqsproto-$VERSION-orig
