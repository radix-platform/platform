#!/bin/sh

VERSION=3.8.0

tar --files-from=file.list -xJvf ../llvm-$VERSION.src.tar.xz
mv llvm-$VERSION.src llvm-$VERSION.src-orig

cp -rf ./llvm-$VERSION.src-new ./llvm-$VERSION.src

diff -b --unified -Nr  llvm-$VERSION.src-orig  llvm-$VERSION.src > llvm-$VERSION.patch

mv llvm-$VERSION.patch ../patches

rm -rf ./llvm-$VERSION.src
rm -rf ./llvm-$VERSION.src-orig
