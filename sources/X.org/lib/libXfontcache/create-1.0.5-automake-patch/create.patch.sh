#!/bin/sh

VERSION=1.0.5

tar --files-from=file.list -xjvf ../libXfontcache-$VERSION.tar.bz2
mv libXfontcache-$VERSION libXfontcache-$VERSION-orig

cp -rf ./libXfontcache-$VERSION-new ./libXfontcache-$VERSION

diff -b --unified -Nr  libXfontcache-$VERSION-orig  libXfontcache-$VERSION > libXfontcache-$VERSION-automake.patch

mv libXfontcache-$VERSION-automake.patch ../patches

rm -rf ./libXfontcache-$VERSION
rm -rf ./libXfontcache-$VERSION-orig
