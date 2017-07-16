#!/bin/sh

VERSION=1.0.4

tar --files-from=file.list -xjvf ../xlogo-$VERSION.tar.bz2
mv xlogo-$VERSION xlogo-$VERSION-orig

cp -rf ./xlogo-$VERSION-new ./xlogo-$VERSION

diff -b --unified -Nr  xlogo-$VERSION-orig  xlogo-$VERSION > xlogo-$VERSION-automake.patch

mv xlogo-$VERSION-automake.patch ../patches

rm -rf ./xlogo-$VERSION
rm -rf ./xlogo-$VERSION-orig
