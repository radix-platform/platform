#!/bin/sh

VERSION=1.0.4

tar --files-from=file.list -xjvf ../constype-$VERSION.tar.bz2
mv constype-$VERSION constype-$VERSION-orig

cp -rf ./constype-$VERSION-new ./constype-$VERSION

diff -b --unified -Nr  constype-$VERSION-orig  constype-$VERSION > constype-$VERSION-automake.patch

mv constype-$VERSION-automake.patch ../patches

rm -rf ./constype-$VERSION
rm -rf ./constype-$VERSION-orig
