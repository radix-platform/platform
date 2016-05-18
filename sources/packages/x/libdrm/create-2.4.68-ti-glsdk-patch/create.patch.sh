#!/bin/sh

VERSION=2.4.68

tar --files-from=file.list -xjvf ../libdrm-$VERSION.tar.bz2
mv libdrm-$VERSION libdrm-$VERSION-orig

cp -rf ./libdrm-$VERSION-new ./libdrm-$VERSION

diff -b --unified -Nr  libdrm-$VERSION-orig  libdrm-$VERSION > libdrm-$VERSION-ti-glsdk.patch

mv libdrm-$VERSION-ti-glsdk.patch ../patches

rm -rf ./libdrm-$VERSION
rm -rf ./libdrm-$VERSION-orig
