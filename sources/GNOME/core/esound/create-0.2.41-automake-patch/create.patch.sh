#!/bin/sh

VERSION=0.2.41

tar --files-from=file.list -xjvf ../esound-$VERSION.tar.bz2
mv esound-$VERSION esound-$VERSION-orig

cp -rf ./esound-$VERSION-new ./esound-$VERSION

diff -b --unified -Nr  esound-$VERSION-orig  esound-$VERSION > esound-$VERSION-automake.patch

mv esound-$VERSION-automake.patch ../patches

rm -rf ./esound-$VERSION
rm -rf ./esound-$VERSION-orig
