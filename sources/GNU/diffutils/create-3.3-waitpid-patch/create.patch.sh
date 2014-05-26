#!/bin/sh

VERSION=3.3

tar --files-from=file.list -xJvf ../diffutils-$VERSION.tar.xz
mv diffutils-$VERSION diffutils-$VERSION-orig

cp -rf ./diffutils-$VERSION-new ./diffutils-$VERSION

diff -b --unified -Nr  diffutils-$VERSION-orig  diffutils-$VERSION > diffutils-$VERSION-waitpid.patch

mv diffutils-$VERSION-waitpid.patch ../patches

rm -rf ./diffutils-$VERSION
rm -rf ./diffutils-$VERSION-orig
