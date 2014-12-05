#!/bin/sh

VERSION=4.5

tar --files-from=file.list -xjvf ../docbook-xml-$VERSION.tar.bz2
mv docbook-xml-$VERSION docbook-xml-$VERSION-orig

cp -rf ./docbook-xml-$VERSION-new ./docbook-xml-$VERSION

diff -b --unified -Nr  docbook-xml-$VERSION-orig docbook-xml-$VERSION > docbook-xml-$VERSION.patch

mv docbook-xml-$VERSION.patch ../patches

rm -rf ./docbook-xml-$VERSION
rm -rf ./docbook-xml-$VERSION-orig
