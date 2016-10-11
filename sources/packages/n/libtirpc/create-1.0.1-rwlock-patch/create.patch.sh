#!/bin/sh

VERSION=1.0.1

tar --files-from=file.list -xjvf ../libtirpc-$VERSION.tar.bz2
mv libtirpc-$VERSION libtirpc-$VERSION-orig

cp -rf ./libtirpc-$VERSION-new ./libtirpc-$VERSION

diff -b --unified -Nr  libtirpc-$VERSION-orig  libtirpc-$VERSION > libtirpc-$VERSION-rwlock.patch

mv libtirpc-$VERSION-rwlock.patch ../patches

rm -rf ./libtirpc-$VERSION
rm -rf ./libtirpc-$VERSION-orig
