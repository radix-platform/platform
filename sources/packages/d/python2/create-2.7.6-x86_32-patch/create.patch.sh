#!/bin/sh

VERSION=2.7.6

tar --files-from=file.list -xJvf ../Python-$VERSION.tar.xz
mv Python-$VERSION Python-$VERSION-orig

cp -rf ./Python-$VERSION-new ./Python-$VERSION

diff -b --unified -Nr  Python-$VERSION-orig  Python-$VERSION > Python-$VERSION-x86_32.patch

mv Python-$VERSION-x86_32.patch ../patches

rm -rf ./Python-$VERSION
rm -rf ./Python-$VERSION-orig
