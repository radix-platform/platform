#!/bin/sh

VERSION=1.5.5

tar --files-from=file.list -xjvf ../keyutils-$VERSION.tar.bz2
mv keyutils-$VERSION keyutils-$VERSION-orig

cp -rf ./keyutils-$VERSION-new ./keyutils-$VERSION

diff -b --unified -Nr  keyutils-$VERSION-orig  keyutils-$VERSION > keyutils-$VERSION.patch

mv keyutils-$VERSION.patch ../patches

rm -rf ./keyutils-$VERSION
rm -rf ./keyutils-$VERSION-orig
