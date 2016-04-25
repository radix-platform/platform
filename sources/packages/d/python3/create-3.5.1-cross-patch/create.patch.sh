#!/bin/sh

VERSION=3.5.1

tar --files-from=file.list -xJvf ../Python-$VERSION.tar.xz
mv Python-$VERSION Python-$VERSION-orig

cp -rf ./Python-$VERSION-new ./Python-$VERSION

diff --unified -Nr  Python-$VERSION-orig  Python-$VERSION > Python-$VERSION-cross.patch

mv Python-$VERSION-cross.patch ../patches

rm -rf ./Python-$VERSION
rm -rf ./Python-$VERSION-orig
