#!/bin/sh

VERSION=2.8

tar --files-from=file.list -xjvf ../dri2proto-$VERSION.tar.bz2
mv dri2proto-$VERSION dri2proto-$VERSION-orig

cp -rf ./dri2proto-$VERSION-new ./dri2proto-$VERSION

diff -b --unified -Nr  dri2proto-$VERSION-orig  dri2proto-$VERSION > dri2proto-$VERSION-ti-glsdk.patch

mv dri2proto-$VERSION-ti-glsdk.patch ../patches

rm -rf ./dri2proto-$VERSION
rm -rf ./dri2proto-$VERSION-orig
