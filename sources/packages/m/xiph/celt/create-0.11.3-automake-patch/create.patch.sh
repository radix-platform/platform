#!/bin/sh

VERSION=0.11.3

tar --files-from=file.list -xzvf ../celt-$VERSION.tar.gz
mv celt-$VERSION celt-$VERSION-orig

cp -rf ./celt-$VERSION-new ./celt-$VERSION

diff -b --unified -Nr  celt-$VERSION-orig  celt-$VERSION > celt-$VERSION-automake.patch

mv celt-$VERSION-automake.patch ../patches

rm -rf ./celt-$VERSION
rm -rf ./celt-$VERSION-orig
