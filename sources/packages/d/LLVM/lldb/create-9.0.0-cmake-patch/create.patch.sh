#!/bin/sh

VERSION=9.0.0

tar --files-from=file.list -xJvf ../lldb-$VERSION.src.tar.xz
mv lldb-$VERSION.src lldb-$VERSION.src-orig

cp -rf ./lldb-$VERSION.src-new ./lldb-$VERSION.src

diff -b --unified -Nr  lldb-$VERSION.src-orig  lldb-$VERSION.src > lldb-$VERSION-cmake.patch

mv lldb-$VERSION-cmake.patch ../patches

rm -rf ./lldb-$VERSION.src
rm -rf ./lldb-$VERSION.src-orig
