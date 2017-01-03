#!/bin/sh

VERSION=1.0.4

tar --files-from=file.list -xjvf ../font-xfree86-type1-$VERSION.tar.bz2
mv font-xfree86-type1-$VERSION font-xfree86-type1-$VERSION-orig

cp -rf ./font-xfree86-type1-$VERSION-new ./font-xfree86-type1-$VERSION

diff -b --unified -Nr  font-xfree86-type1-$VERSION-orig  font-xfree86-type1-$VERSION > font-xfree86-type1-$VERSION-automake.patch

mv font-xfree86-type1-$VERSION-automake.patch ../patches

rm -rf ./font-xfree86-type1-$VERSION
rm -rf ./font-xfree86-type1-$VERSION-orig
