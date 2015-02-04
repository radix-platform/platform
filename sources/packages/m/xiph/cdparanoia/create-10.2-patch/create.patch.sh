#!/bin/sh

VERSION=10.2

tar --files-from=file.list -xzvf ../cdparanoia-III-$VERSION.tar.gz
mv cdparanoia-III-$VERSION cdparanoia-III-$VERSION-orig

cp -rf ./cdparanoia-III-$VERSION-new ./cdparanoia-III-$VERSION

diff -b --unified -Nr  cdparanoia-III-$VERSION-orig  cdparanoia-III-$VERSION > cdparanoia-$VERSION.patch

mv cdparanoia-$VERSION.patch ../patches

rm -rf ./cdparanoia-III-$VERSION
rm -rf ./cdparanoia-III-$VERSION-orig
