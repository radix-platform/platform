#!/bin/sh

VERSION=0.4

tar --files-from=file.list -xzvf ../xmltoman-$VERSION.tar.gz
mv xmltoman-$VERSION xmltoman-$VERSION-orig

cp -rf ./xmltoman-$VERSION-new ./xmltoman-$VERSION

diff -b --unified -Nr  xmltoman-$VERSION-orig  xmltoman-$VERSION > xmltoman-$VERSION.patch

mv xmltoman-$VERSION.patch ../patches

rm -rf ./xmltoman-$VERSION
rm -rf ./xmltoman-$VERSION-orig
