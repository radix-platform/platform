#!/bin/sh

VERSION=2.0.2

tar --files-from=file.list -xzvf ../ices-$VERSION.tar.gz
mv ices-$VERSION ices-$VERSION-orig

cp -rf ./ices-$VERSION-new ./ices-$VERSION

diff -b --unified -Nr  ices-$VERSION-orig  ices-$VERSION > ices-$VERSION-automake.patch

mv ices-$VERSION-automake.patch ../patches

rm -rf ./ices-$VERSION
rm -rf ./ices-$VERSION-orig
