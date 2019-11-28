#!/bin/sh

VERSION=9.0.0

tar --files-from=file.list -xJvf ../llvm-$VERSION.src.tar.xz
mv llvm-$VERSION.src llvm-$VERSION.src-orig

cp -rf ./llvm-$VERSION.src-new ./llvm-$VERSION.src

diff -b --unified -Nr  llvm-$VERSION.src-orig  llvm-$VERSION.src > llvm-$VERSION-curses-to-native.patch

mv llvm-$VERSION-curses-to-native.patch ../patches

rm -rf ./llvm-$VERSION.src
rm -rf ./llvm-$VERSION.src-orig
