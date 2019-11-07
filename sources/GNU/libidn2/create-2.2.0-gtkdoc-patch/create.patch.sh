#!/bin/sh

VERSION=2.2.0

tar --files-from=file.list -xJvf ../libidn2-$VERSION.tar.xz
mv libidn2-$VERSION libidn2-$VERSION-orig

cp -rf ./libidn2-$VERSION-new ./libidn2-$VERSION

diff -b --unified -Nr  libidn2-$VERSION-orig  libidn2-$VERSION > libidn2-$VERSION-gtkdoc.patch

mv libidn2-$VERSION-gtkdoc.patch ../patches

rm -rf ./libidn2-$VERSION
rm -rf ./libidn2-$VERSION-orig
