#!/bin/sh

VERSION=0.8

tar --files-from=file.list -xJvf ../libasyncns-$VERSION.tar.xz
mv libasyncns-$VERSION libasyncns-$VERSION-orig

cp -rf ./libasyncns-$VERSION-new ./libasyncns-$VERSION

diff -b --unified -Nr  libasyncns-$VERSION-orig  libasyncns-$VERSION > libasyncns-$VERSION-rpl-malloc.patch

mv libasyncns-$VERSION-rpl-malloc.patch ../patches

rm -rf ./libasyncns-$VERSION
rm -rf ./libasyncns-$VERSION-orig
