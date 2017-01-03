#!/bin/sh

VERSION=1.2.2

tar --files-from=file.list -xjvf ../libXScrnSaver-$VERSION.tar.bz2
mv libXScrnSaver-$VERSION libXScrnSaver-$VERSION-orig

cp -rf ./libXScrnSaver-$VERSION-new ./libXScrnSaver-$VERSION

diff -b --unified -Nr  libXScrnSaver-$VERSION-orig  libXScrnSaver-$VERSION > libXScrnSaver-$VERSION-automake.patch

mv libXScrnSaver-$VERSION-automake.patch ../patches

rm -rf ./libXScrnSaver-$VERSION
rm -rf ./libXScrnSaver-$VERSION-orig
