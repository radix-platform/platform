#!/bin/sh

VERSION=1.0.4

tar --files-from=file.list -xjvf ../font-adobe-utopia-type1-$VERSION.tar.bz2
mv font-adobe-utopia-type1-$VERSION font-adobe-utopia-type1-$VERSION-orig

cp -rf ./font-adobe-utopia-type1-$VERSION-new ./font-adobe-utopia-type1-$VERSION

diff -b --unified -Nr  font-adobe-utopia-type1-$VERSION-orig  font-adobe-utopia-type1-$VERSION > font-adobe-utopia-type1-$VERSION-automake.patch

mv font-adobe-utopia-type1-$VERSION-automake.patch ../patches

rm -rf ./font-adobe-utopia-type1-$VERSION
rm -rf ./font-adobe-utopia-type1-$VERSION-orig
