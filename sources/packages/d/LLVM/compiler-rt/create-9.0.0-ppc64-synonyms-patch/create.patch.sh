#!/bin/sh

VERSION=9.0.0

tar --files-from=file.list -xJvf ../compiler-rt-$VERSION.src.tar.xz
mv compiler-rt-$VERSION.src compiler-rt-$VERSION.src-orig

cp -rf ./compiler-rt-$VERSION.src-new ./compiler-rt-$VERSION.src

diff -b --unified -Nr  compiler-rt-$VERSION.src-orig  compiler-rt-$VERSION.src > compiler-rt-$VERSION-ppc64-synonyms.patch

mv compiler-rt-$VERSION-ppc64-synonyms.patch ../patches

rm -rf ./compiler-rt-$VERSION.src
rm -rf ./compiler-rt-$VERSION.src-orig
