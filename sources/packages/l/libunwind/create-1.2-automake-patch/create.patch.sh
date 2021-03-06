#!/bin/sh

VERSION=1.2

tar --files-from=file.list -xzvf ../libunwind-$VERSION.tar.gz
mv libunwind-$VERSION libunwind-$VERSION-orig

cp -rf ./libunwind-$VERSION-new ./libunwind-$VERSION

diff -b --unified -Nr  libunwind-$VERSION-orig  libunwind-$VERSION > libunwind-$VERSION-automake.patch

mv libunwind-$VERSION-automake.patch ../patches

rm -rf ./libunwind-$VERSION
rm -rf ./libunwind-$VERSION-orig
