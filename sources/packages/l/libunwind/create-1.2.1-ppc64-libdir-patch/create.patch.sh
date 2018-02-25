#!/bin/sh

VERSION=1.2.1

tar --files-from=file.list -xzvf ../libunwind-$VERSION.tar.gz
mv libunwind-$VERSION libunwind-$VERSION-orig

cp -rf ./libunwind-$VERSION-new ./libunwind-$VERSION

diff -b --unified -Nr  libunwind-$VERSION-orig  libunwind-$VERSION > libunwind-$VERSION-ppc64-libdir.patch

mv libunwind-$VERSION-ppc64-libdir.patch ../patches

rm -rf ./libunwind-$VERSION
rm -rf ./libunwind-$VERSION-orig