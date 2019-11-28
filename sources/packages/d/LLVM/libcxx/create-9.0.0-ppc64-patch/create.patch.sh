#!/bin/sh

VERSION=9.0.0

tar --files-from=file.list -xJvf ../libcxx-$VERSION.src.tar.xz
mv libcxx-$VERSION.src libcxx-$VERSION.src-orig

cp -rf ./libcxx-$VERSION.src-new ./libcxx-$VERSION.src

diff -b --unified -Nr  libcxx-$VERSION.src-orig  libcxx-$VERSION.src > libcxx-$VERSION-ppc64.patch

mv libcxx-$VERSION-ppc64.patch ../patches

rm -rf ./libcxx-$VERSION.src
rm -rf ./libcxx-$VERSION.src-orig
