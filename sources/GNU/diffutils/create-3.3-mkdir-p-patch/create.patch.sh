#!/bin/sh

VERSION=3.3

tar --files-from=file.list -xJf ../diffutils-$VERSION.tar.xz
mv diffutils-$VERSION diffutils-$VERSION-orig

cp -rf ./diffutils-$VERSION-new ./diffutils-$VERSION

diff -b --unified -Nr  diffutils-$VERSION-orig  diffutils-$VERSION > diffutils-$VERSION-mkdir-p.patch

mv diffutils-$VERSION-mkdir-p.patch ../patches

rm -rf ./diffutils-$VERSION
rm -rf ./diffutils-$VERSION-orig
