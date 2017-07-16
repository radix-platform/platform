#!/bin/sh

VERSION=1.2.1

tar --files-from=file.list -xjvf ../xineramaproto-$VERSION.tar.bz2
mv xineramaproto-$VERSION xineramaproto-$VERSION-orig

cp -rf ./xineramaproto-$VERSION-new ./xineramaproto-$VERSION

diff -b --unified -Nr  xineramaproto-$VERSION-orig  xineramaproto-$VERSION > xineramaproto-$VERSION-automake.patch

mv xineramaproto-$VERSION-automake.patch ../patches

rm -rf ./xineramaproto-$VERSION
rm -rf ./xineramaproto-$VERSION-orig
