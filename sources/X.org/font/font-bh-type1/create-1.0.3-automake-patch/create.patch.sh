#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../font-bh-type1-$VERSION.tar.bz2
mv font-bh-type1-$VERSION font-bh-type1-$VERSION-orig

cp -rf ./font-bh-type1-$VERSION-new ./font-bh-type1-$VERSION

diff -b --unified -Nr  font-bh-type1-$VERSION-orig  font-bh-type1-$VERSION > font-bh-type1-$VERSION-automake.patch

mv font-bh-type1-$VERSION-automake.patch ../patches

rm -rf ./font-bh-type1-$VERSION
rm -rf ./font-bh-type1-$VERSION-orig
