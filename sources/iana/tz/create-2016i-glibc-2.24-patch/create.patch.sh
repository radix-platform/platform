#!/bin/sh

VERSION=2016i
GLIBC_VERSION=2.24

mkdir -p glibc-$GLIBC_VERSION/timezone
tar -C glibc-$GLIBC_VERSION/timezone --files-from=file.list -xzvf ../tzcode$VERSION.tar.gz
mv glibc-$GLIBC_VERSION glibc-$GLIBC_VERSION-orig

cp -rf ./glibc-$GLIBC_VERSION-new ./glibc-$GLIBC_VERSION

diff -b --unified -Nr  glibc-$GLIBC_VERSION-orig  glibc-$GLIBC_VERSION > glibc-$GLIBC_VERSION-tzcode-$VERSION.patch

mv glibc-$GLIBC_VERSION-tzcode-$VERSION.patch ../patches

rm -rf ./glibc-$GLIBC_VERSION
rm -rf ./glibc-$GLIBC_VERSION-orig
