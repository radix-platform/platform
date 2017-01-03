#!/bin/sh

VERSION=0.3.13

tar --files-from=file.list -xzvf ../twolame-$VERSION.tar.gz
mv twolame-$VERSION twolame-$VERSION-orig

cp -rf ./twolame-$VERSION-new ./twolame-$VERSION

diff -b --unified -Nr  twolame-$VERSION-orig  twolame-$VERSION > twolame-$VERSION-automake.patch

mv twolame-$VERSION-automake.patch ../patches

rm -rf ./twolame-$VERSION
rm -rf ./twolame-$VERSION-orig
