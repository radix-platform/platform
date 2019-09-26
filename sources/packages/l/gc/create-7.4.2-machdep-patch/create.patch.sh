#!/bin/sh

VERSION=7.4.2

tar --files-from=file.list -xzvf ../gc-${VERSION}.tar.gz
mv gc-$VERSION gc-$VERSION-orig

cp -rf ./gc-$VERSION-new ./gc-$VERSION

diff -b --unified -Nr  gc-$VERSION-orig  gc-$VERSION > gc-${VERSION}-machdep.patch

mv gc-${VERSION}-machdep.patch ../patches

rm -rf ./gc-$VERSION
rm -rf ./gc-$VERSION-orig
