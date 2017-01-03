#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../font-alias-$VERSION.tar.bz2
mv font-alias-$VERSION font-alias-$VERSION-orig

cp -rf ./font-alias-$VERSION-new ./font-alias-$VERSION

diff -b --unified -Nr  font-alias-$VERSION-orig  font-alias-$VERSION > font-alias-$VERSION-automake.patch

mv font-alias-$VERSION-automake.patch ../patches

rm -rf ./font-alias-$VERSION
rm -rf ./font-alias-$VERSION-orig
