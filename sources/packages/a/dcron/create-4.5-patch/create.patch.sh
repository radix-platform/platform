#!/bin/sh

VERSION=4.5

tar --files-from=file.list -xzvf ../dcron-$VERSION.tar.gz
mv dcron-$VERSION dcron-$VERSION-orig

cp -rf ./dcron-$VERSION-new ./dcron-$VERSION

diff -b --unified -Nr  dcron-$VERSION-orig  dcron-$VERSION > dcron-$VERSION.patch

mv dcron-$VERSION.patch ../patches

rm -rf ./dcron-$VERSION
rm -rf ./dcron-$VERSION-orig
