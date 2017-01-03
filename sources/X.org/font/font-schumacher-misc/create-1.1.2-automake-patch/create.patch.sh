#!/bin/sh

VERSION=1.1.2

tar --files-from=file.list -xjvf ../font-schumacher-misc-$VERSION.tar.bz2
mv font-schumacher-misc-$VERSION font-schumacher-misc-$VERSION-orig

cp -rf ./font-schumacher-misc-$VERSION-new ./font-schumacher-misc-$VERSION

diff -b --unified -Nr  font-schumacher-misc-$VERSION-orig  font-schumacher-misc-$VERSION > font-schumacher-misc-$VERSION-automake.patch

mv font-schumacher-misc-$VERSION-automake.patch ../patches

rm -rf ./font-schumacher-misc-$VERSION
rm -rf ./font-schumacher-misc-$VERSION-orig
