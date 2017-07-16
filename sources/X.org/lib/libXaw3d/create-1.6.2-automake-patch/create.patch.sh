#!/bin/sh

VERSION=1.6.2

tar --files-from=file.list -xjvf ../libXaw3d-$VERSION.tar.bz2
mv libXaw3d-$VERSION libXaw3d-$VERSION-orig

cp -rf ./libXaw3d-$VERSION-new ./libXaw3d-$VERSION

diff -b --unified -Nr  libXaw3d-$VERSION-orig  libXaw3d-$VERSION > libXaw3d-$VERSION-automake.patch

mv libXaw3d-$VERSION-automake.patch ../patches

rm -rf ./libXaw3d-$VERSION
rm -rf ./libXaw3d-$VERSION-orig
