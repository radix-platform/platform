#!/bin/sh

VERSION=1.2.2

tar --files-from=file.list -xjvf ../scrnsaverproto-$VERSION.tar.bz2
mv scrnsaverproto-$VERSION scrnsaverproto-$VERSION-orig

cp -rf ./scrnsaverproto-$VERSION-new ./scrnsaverproto-$VERSION

diff -b --unified -Nr  scrnsaverproto-$VERSION-orig  scrnsaverproto-$VERSION > scrnsaverproto-$VERSION-automake.patch

mv scrnsaverproto-$VERSION-automake.patch ../patches

rm -rf ./scrnsaverproto-$VERSION
rm -rf ./scrnsaverproto-$VERSION-orig
