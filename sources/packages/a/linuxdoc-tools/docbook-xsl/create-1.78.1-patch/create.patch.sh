#!/bin/sh

VERSION=1.78.1

tar --files-from=file.list -xjvf ../docbook-xsl-$VERSION.tar.bz2
mv docbook-xsl-$VERSION docbook-xsl-$VERSION-orig

cp -rf ./docbook-xsl-$VERSION-new ./docbook-xsl-$VERSION

diff -b --unified -Nr  docbook-xsl-$VERSION-orig docbook-xsl-$VERSION > docbook-xsl-$VERSION.patch

mv docbook-xsl-$VERSION.patch ../patches

rm -rf ./docbook-xsl-$VERSION
rm -rf ./docbook-xsl-$VERSION-orig
