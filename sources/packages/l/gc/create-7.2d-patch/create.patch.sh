#!/bin/sh

VERSION=7.2

tar --files-from=file.list -xzvf ../gc-${VERSION}d.tar.gz
mv gc-$VERSION gc-$VERSION-orig

cp -rf ./gc-$VERSION-new ./gc-$VERSION

diff -b --unified -Nr  gc-$VERSION-orig  gc-$VERSION > gc-${VERSION}d.patch

mv gc-${VERSION}d.patch ../patches

rm -rf ./gc-$VERSION
rm -rf ./gc-$VERSION-orig
