#!/bin/sh

VERSION=2.24

tar --files-from=file.list -xJvf ../libcap-$VERSION.tar.xz
mv libcap-$VERSION libcap-$VERSION-orig

cp -rf ./libcap-$VERSION-new ./libcap-$VERSION

diff -b --unified -Nr  libcap-$VERSION-orig  libcap-$VERSION > libcap-$VERSION.patch

mv libcap-$VERSION.patch ../patches

rm -rf ./libcap-$VERSION
rm -rf ./libcap-$VERSION-orig
