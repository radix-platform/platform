#!/bin/sh

VERSION=0.6.21

tar --files-from=file.list -xjvf ../libexif-$VERSION.tar.bz2
mv libexif-$VERSION libexif-$VERSION-orig

cp -rf ./libexif-$VERSION-new ./libexif-$VERSION

diff -b --unified -Nr  libexif-$VERSION-orig  libexif-$VERSION > libexif-$VERSION-automake.patch

mv libexif-$VERSION-automake.patch ../patches

rm -rf ./libexif-$VERSION
rm -rf ./libexif-$VERSION-orig
