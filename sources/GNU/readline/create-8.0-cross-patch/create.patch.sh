#!/bin/sh

VERSION=8.0

tar --files-from=file.list -xzvf ../readline-$VERSION.tar.gz
mv readline-$VERSION readline-$VERSION-orig

cp -rf ./readline-$VERSION-new ./readline-$VERSION

diff -b --unified -Nr  readline-$VERSION-orig  readline-$VERSION > readline-$VERSION-cross.patch

mv readline-$VERSION-cross.patch ../patches

rm -rf ./readline-$VERSION
rm -rf ./readline-$VERSION-orig
