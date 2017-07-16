#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../font-winitzki-cyrillic-$VERSION.tar.bz2
mv font-winitzki-cyrillic-$VERSION font-winitzki-cyrillic-$VERSION-orig

cp -rf ./font-winitzki-cyrillic-$VERSION-new ./font-winitzki-cyrillic-$VERSION

diff -b --unified -Nr  font-winitzki-cyrillic-$VERSION-orig  font-winitzki-cyrillic-$VERSION > font-winitzki-cyrillic-$VERSION-automake.patch

mv font-winitzki-cyrillic-$VERSION-automake.patch ../patches

rm -rf ./font-winitzki-cyrillic-$VERSION
rm -rf ./font-winitzki-cyrillic-$VERSION-orig
