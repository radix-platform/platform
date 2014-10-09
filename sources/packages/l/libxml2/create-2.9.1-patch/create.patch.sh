#!/bin/sh

VERSION=2.9.1

tar --files-from=file.list -xzvf ../libxml2-$VERSION.tar.gz
mv libxml2-$VERSION libxml2-$VERSION-orig

cp -rf ./libxml2-$VERSION-new ./libxml2-$VERSION

diff -b --unified -Nr  libxml2-$VERSION-orig  libxml2-$VERSION > libxml2-$VERSION.patch

mv libxml2-$VERSION.patch ../patches

rm -rf ./libxml2-$VERSION
rm -rf ./libxml2-$VERSION-orig
