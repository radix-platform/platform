#!/bin/sh

VERSION=3.4.8

tar --files-from=file.list -xJvf ../gnutls-$VERSION.tar.xz
mv gnutls-$VERSION gnutls-$VERSION-orig

cp -rf ./gnutls-$VERSION-new ./gnutls-$VERSION

diff -b --unified -Nr  gnutls-$VERSION-orig  gnutls-$VERSION > gnutls-$VERSION-gtkdoc.patch

mv gnutls-$VERSION-gtkdoc.patch ../patches

rm -rf ./gnutls-$VERSION
rm -rf ./gnutls-$VERSION-orig
