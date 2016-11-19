#!/bin/sh

VERSION=3.5.1

tar --files-from=file.list -xJvf ../Python-$VERSION.tar.xz
mv Python-$VERSION Python-$VERSION-orig

cp -rf ./Python-$VERSION-new ./Python-$VERSION

diff -b --unified -Nr  Python-$VERSION-orig  Python-$VERSION > Python-$VERSION-readline.patch

mv Python-$VERSION-readline.patch ../patches

rm -rf ./Python-$VERSION
rm -rf ./Python-$VERSION-orig
