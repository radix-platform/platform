#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../font-misc-meltho-$VERSION.tar.bz2
mv font-misc-meltho-$VERSION font-misc-meltho-$VERSION-orig

cp -rf ./font-misc-meltho-$VERSION-new ./font-misc-meltho-$VERSION

diff -b --unified -Nr  font-misc-meltho-$VERSION-orig  font-misc-meltho-$VERSION > font-misc-meltho-$VERSION-automake.patch

mv font-misc-meltho-$VERSION-automake.patch ../patches

rm -rf ./font-misc-meltho-$VERSION
rm -rf ./font-misc-meltho-$VERSION-orig
