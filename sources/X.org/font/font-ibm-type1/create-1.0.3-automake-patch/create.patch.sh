#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../font-ibm-type1-$VERSION.tar.bz2
mv font-ibm-type1-$VERSION font-ibm-type1-$VERSION-orig

cp -rf ./font-ibm-type1-$VERSION-new ./font-ibm-type1-$VERSION

diff -b --unified -Nr  font-ibm-type1-$VERSION-orig  font-ibm-type1-$VERSION > font-ibm-type1-$VERSION-automake.patch

mv font-ibm-type1-$VERSION-automake.patch ../patches

rm -rf ./font-ibm-type1-$VERSION
rm -rf ./font-ibm-type1-$VERSION-orig
