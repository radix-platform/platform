#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../font-bh-ttf-$VERSION.tar.bz2
mv font-bh-ttf-$VERSION font-bh-ttf-$VERSION-orig

cp -rf ./font-bh-ttf-$VERSION-new ./font-bh-ttf-$VERSION

diff -b --unified -Nr  font-bh-ttf-$VERSION-orig  font-bh-ttf-$VERSION > font-bh-ttf-$VERSION-automake.patch

mv font-bh-ttf-$VERSION-automake.patch ../patches

rm -rf ./font-bh-ttf-$VERSION
rm -rf ./font-bh-ttf-$VERSION-orig
