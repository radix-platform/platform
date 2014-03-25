#!/bin/sh

VERSION=1.16

tar --files-from=file.list -xzvf ../popt-$VERSION.tar.gz
mv popt-$VERSION popt-$VERSION-orig

cp -rf ./popt-$VERSION-new ./popt-$VERSION

diff -b --unified -Nr  popt-$VERSION-orig  popt-$VERSION  > ../patches/popt-$VERSION.patch

rm -rf ./popt-$VERSION
rm -rf ./popt-$VERSION-orig
