#!/bin/sh

VERSION=0.3

tar --files-from=file.list -xjvf ../libpthread-stubs-$VERSION.tar.bz2
mv libpthread-stubs-$VERSION libpthread-stubs-$VERSION-orig

cp -rf ./libpthread-stubs-$VERSION-new ./libpthread-stubs-$VERSION

diff -b --unified -Nr  libpthread-stubs-$VERSION-orig  libpthread-stubs-$VERSION > libpthread-stubs-$VERSION-automake.patch

mv libpthread-stubs-$VERSION-automake.patch ../patches

rm -rf ./libpthread-stubs-$VERSION
rm -rf ./libpthread-stubs-$VERSION-orig
