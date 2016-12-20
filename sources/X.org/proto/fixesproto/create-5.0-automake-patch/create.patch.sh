#!/bin/sh

VERSION=5.0

tar --files-from=file.list -xjvf ../fixesproto-$VERSION.tar.bz2
mv fixesproto-$VERSION fixesproto-$VERSION-orig

cp -rf ./fixesproto-$VERSION-new ./fixesproto-$VERSION

diff -b --unified -Nr  fixesproto-$VERSION-orig  fixesproto-$VERSION > fixesproto-$VERSION-automake.patch

mv fixesproto-$VERSION-automake.patch ../patches

rm -rf ./fixesproto-$VERSION
rm -rf ./fixesproto-$VERSION-orig
