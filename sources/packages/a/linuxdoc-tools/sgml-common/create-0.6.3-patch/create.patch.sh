#!/bin/sh

VERSION=0.6.3

tar --files-from=file.list -xjvf ../sgml-common-$VERSION.tar.bz2
mv sgml-common-$VERSION sgml-common-$VERSION-orig

cp -rf ./sgml-common-$VERSION-new ./sgml-common-$VERSION

diff -b --unified -Nr  sgml-common-$VERSION-orig sgml-common-$VERSION > sgml-common-$VERSION.patch

mv sgml-common-$VERSION.patch ../patches

rm -rf ./sgml-common-$VERSION
rm -rf ./sgml-common-$VERSION-orig
