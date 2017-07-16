#!/bin/sh

VERSION=0.4.4

tar --files-from=file.list -xjvf ../libXcomposite-$VERSION.tar.bz2
mv libXcomposite-$VERSION libXcomposite-$VERSION-orig

cp -rf ./libXcomposite-$VERSION-new ./libXcomposite-$VERSION

diff -b --unified -Nr  libXcomposite-$VERSION-orig  libXcomposite-$VERSION > libXcomposite-$VERSION-automake.patch

mv libXcomposite-$VERSION-automake.patch ../patches

rm -rf ./libXcomposite-$VERSION
rm -rf ./libXcomposite-$VERSION-orig
