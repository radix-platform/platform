#!/bin/sh

VERSION=1.35

tar --files-from=file.list -xzvf ../libidn-$VERSION.tar.gz
mv libidn-$VERSION libidn-$VERSION-orig

cp -rf ./libidn-$VERSION-new ./libidn-$VERSION

diff -b --unified -Nr  libidn-$VERSION-orig  libidn-$VERSION > libidn-$VERSION-gtkdoc.patch

mv libidn-$VERSION-gtkdoc.patch ../patches

rm -rf ./libidn-$VERSION
rm -rf ./libidn-$VERSION-orig
