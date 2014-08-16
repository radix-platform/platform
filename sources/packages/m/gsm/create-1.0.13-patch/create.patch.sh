#!/bin/sh

VERSION=1.0-pl13
TARBALL=1.0.13

tar --files-from=file.list -xzvf ../gsm-$TARBALL.tar.gz
mv gsm-$VERSION gsm-$VERSION-orig

cp -rf ./gsm-$VERSION-new ./gsm-$VERSION

diff -b --unified -Nr  gsm-$VERSION-orig  gsm-$VERSION > gsm-$TARBALL.patch

mv gsm-$TARBALL.patch ../patches

rm -rf ./gsm-$VERSION
rm -rf ./gsm-$VERSION-orig
