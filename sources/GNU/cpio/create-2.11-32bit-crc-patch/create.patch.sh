#!/bin/sh

VERSION=2.11

tar --files-from=file.list -xjvf ../cpio-$VERSION.tar.bz2
mv cpio-$VERSION cpio-$VERSION-orig

cp -rf ./cpio-$VERSION-new ./cpio-$VERSION

diff -b --unified -Nr  cpio-$VERSION-orig  cpio-$VERSION > cpio-$VERSION-32bit-crc.patch

mv cpio-$VERSION-32bit-crc.patch ../patches

rm -rf ./cpio-$VERSION
rm -rf ./cpio-$VERSION-orig
