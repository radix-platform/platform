#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../font-isas-misc-$VERSION.tar.bz2
mv font-isas-misc-$VERSION font-isas-misc-$VERSION-orig

cp -rf ./font-isas-misc-$VERSION-new ./font-isas-misc-$VERSION

diff -b --unified -Nr  font-isas-misc-$VERSION-orig  font-isas-misc-$VERSION > font-isas-misc-$VERSION-automake.patch

mv font-isas-misc-$VERSION-automake.patch ../patches

rm -rf ./font-isas-misc-$VERSION
rm -rf ./font-isas-misc-$VERSION-orig
