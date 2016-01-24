#!/bin/sh

VERSION=2.7.11

tar -xJf ../Python-$VERSION.tar.xz
patch -p0 < ../patches/Python-$VERSION-x86_32.patch > /dev/null 2>&1
tar -cJf Python-$VERSION.tar.xz Python-$VERSION
rm -rf Python-$VERSION

tar --files-from=file.list -xJvf ./Python-$VERSION.tar.xz
rm -f ./Python-$VERSION.tar.xz
mv Python-$VERSION Python-$VERSION-orig

cp -rf ./Python-$VERSION-new ./Python-$VERSION

diff --unified -Nr  Python-$VERSION-orig  Python-$VERSION > Python-$VERSION-cross32.patch

mv Python-$VERSION-cross32.patch ../patches

rm -rf ./Python-$VERSION
rm -rf ./Python-$VERSION-orig
