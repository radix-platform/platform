#!/bin/sh

VERSION=9.0.0

tar --files-from=file.list -xJvf ../cfe-$VERSION.src.tar.xz
mv cfe-$VERSION.src cfe-$VERSION.src-orig

cp -rf ./cfe-$VERSION.src-new ./cfe-$VERSION.src

diff -b --unified -Nr  cfe-$VERSION.src-orig  cfe-$VERSION.src > cfe-$VERSION-set-revision.patch

mv cfe-$VERSION-set-revision.patch ../patches

rm -rf ./cfe-$VERSION.src
rm -rf ./cfe-$VERSION.src-orig
