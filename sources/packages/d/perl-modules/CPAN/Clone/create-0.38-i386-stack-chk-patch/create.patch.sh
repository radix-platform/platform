#!/bin/sh

VERSION=0.38

tar --files-from=file.list -xzvf ../Clone-$VERSION.tar.gz
mv Clone-$VERSION Clone-$VERSION-orig

cp -rf ./Clone-$VERSION-new ./Clone-$VERSION

diff -b --unified -Nr  Clone-$VERSION-orig  Clone-$VERSION > Clone-$VERSION-i386-stack-chk.patch

mv Clone-$VERSION-i386-stack-chk.patch ../patches

rm -rf ./Clone-$VERSION
rm -rf ./Clone-$VERSION-orig
