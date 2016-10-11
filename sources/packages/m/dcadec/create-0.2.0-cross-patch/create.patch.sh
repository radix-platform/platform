#!/bin/sh

VERSION=0.2.0

tar --files-from=file.list -xJvf ../dcadec-$VERSION.tar.xz
mv dcadec-$VERSION dcadec-$VERSION-orig

cp -rf ./dcadec-$VERSION-new ./dcadec-$VERSION

diff -b --unified -Nr  dcadec-$VERSION-orig  dcadec-$VERSION > dcadec-$VERSION-cross.patch

mv dcadec-$VERSION-cross.patch ../patches

rm -rf ./dcadec-$VERSION
rm -rf ./dcadec-$VERSION-orig
