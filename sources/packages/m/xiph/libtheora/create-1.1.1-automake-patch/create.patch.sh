#!/bin/sh

VERSION=1.1.1

tar --files-from=file.list -xjvf ../libtheora-$VERSION.tar.bz2
mv libtheora-$VERSION libtheora-$VERSION-orig

cp -rf ./libtheora-$VERSION-new ./libtheora-$VERSION

diff -b --unified -Nr  libtheora-$VERSION-orig  libtheora-$VERSION > libtheora-$VERSION-automake.patch

mv libtheora-$VERSION-automake.patch ../patches

rm -rf ./libtheora-$VERSION
rm -rf ./libtheora-$VERSION-orig
