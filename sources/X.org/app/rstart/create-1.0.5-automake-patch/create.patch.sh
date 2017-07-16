#!/bin/sh

VERSION=1.0.5

tar --files-from=file.list -xjvf ../rstart-$VERSION.tar.bz2
mv rstart-$VERSION rstart-$VERSION-orig

cp -rf ./rstart-$VERSION-new ./rstart-$VERSION

diff -b --unified -Nr  rstart-$VERSION-orig  rstart-$VERSION > rstart-$VERSION-automake.patch

mv rstart-$VERSION-automake.patch ../patches

rm -rf ./rstart-$VERSION
rm -rf ./rstart-$VERSION-orig
