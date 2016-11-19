#!/bin/sh

VERSION=7.03.00.03

tar --files-from=file.list -xJvf ../glsdk_$VERSION.tar.xz
mv glsdk_$VERSION glsdk_$VERSION-orig

cp -rf ./glsdk_$VERSION-new ./glsdk_$VERSION

diff -b --unified -Nr  glsdk_$VERSION-orig  glsdk_$VERSION > glsdk-$VERSION-dos2unix.patch

mv glsdk-$VERSION-dos2unix.patch ../patches

rm -rf ./glsdk_$VERSION
rm -rf ./glsdk_$VERSION-orig
