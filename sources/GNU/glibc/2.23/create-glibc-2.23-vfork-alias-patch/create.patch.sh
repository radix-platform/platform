#!/bin/sh

VERSION=2.23

tar --files-from=file.list -xJvf ../glibc-$VERSION.tar.xz
mv glibc-$VERSION glibc-$VERSION-orig

cp -rf ./glibc-$VERSION-new ./glibc-$VERSION

diff -b --unified -Nr  glibc-$VERSION-orig  glibc-$VERSION > glibc-$VERSION-vfork-alias.patch

mv glibc-$VERSION-vfork-alias.patch ../patches

rm -rf ./glibc-$VERSION
rm -rf ./glibc-$VERSION-orig