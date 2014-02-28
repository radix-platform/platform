#!/bin/sh

VERSION=2.18.1

tar --files-from=file.list -xjvf ../eglibc-$VERSION.tar.bz2
mv eglibc-$VERSION eglibc-$VERSION-orig

cp -rf ./eglibc-$VERSION-new ./eglibc-$VERSION

diff -b --unified -Nr  eglibc-$VERSION-orig  eglibc-$VERSION > eglibc-$VERSION-zoneinfo.patch

mv eglibc-$VERSION-zoneinfo.patch ../patches

rm -rf ./eglibc-$VERSION
rm -rf ./eglibc-$VERSION-orig
