#!/bin/sh

VERSION=1.3.1

tar --files-from=file.list -xzvf ../libunwind-$VERSION.tar.gz
mv libunwind-$VERSION libunwind-$VERSION-orig

cp -rf ./libunwind-$VERSION-new ./libunwind-$VERSION

diff -b --unified -Nr  libunwind-$VERSION-orig  libunwind-$VERSION > libunwind-$VERSION-configure.patch

mv libunwind-$VERSION-configure.patch ../patches

rm -rf ./libunwind-$VERSION
rm -rf ./libunwind-$VERSION-orig
