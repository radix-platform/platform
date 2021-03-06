#!/bin/sh

VERSION=8.21

tar --files-from=file.list -xJvf ../coreutils-$VERSION.tar.xz
mv coreutils-$VERSION coreutils-$VERSION-orig

cp -rf ./coreutils-$VERSION-new ./coreutils-$VERSION

diff -b --unified -Nr  coreutils-$VERSION-orig  coreutils-$VERSION > coreutils-$VERSION-uname.patch

mv coreutils-$VERSION-uname.patch ../patches

rm -rf ./coreutils-$VERSION
rm -rf ./coreutils-$VERSION-orig
