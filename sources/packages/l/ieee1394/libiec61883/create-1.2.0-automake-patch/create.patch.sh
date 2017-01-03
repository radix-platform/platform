#!/bin/sh

VERSION=1.2.0

tar --files-from=file.list -xJvf ../libiec61883-$VERSION.tar.xz
mv libiec61883-$VERSION libiec61883-$VERSION-orig

cp -rf ./libiec61883-$VERSION-new ./libiec61883-$VERSION

diff -b --unified -Nr  libiec61883-$VERSION-orig  libiec61883-$VERSION > libiec61883-$VERSION-automake.patch

mv libiec61883-$VERSION-automake.patch ../patches

rm -rf ./libiec61883-$VERSION
rm -rf ./libiec61883-$VERSION-orig
