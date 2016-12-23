#!/bin/sh

VERSION=1.0.4

tar --files-from=file.list -xjvf ../xpr-$VERSION.tar.bz2
mv xpr-$VERSION xpr-$VERSION-orig

cp -rf ./xpr-$VERSION-new ./xpr-$VERSION

diff -b --unified -Nr  xpr-$VERSION-orig  xpr-$VERSION > xpr-$VERSION-automake.patch

mv xpr-$VERSION-automake.patch ../patches

rm -rf ./xpr-$VERSION
rm -rf ./xpr-$VERSION-orig
