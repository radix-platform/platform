#!/bin/sh

VERSION=3.99.5

tar --files-from=file.list -xzvf ../lame-$VERSION.tar.gz
mv lame-$VERSION lame-$VERSION-orig

cp -rf ./lame-$VERSION-new ./lame-$VERSION

diff -b --unified -Nr  lame-$VERSION-orig  lame-$VERSION > lame-$VERSION-automake.patch

mv lame-$VERSION-automake.patch ../patches

rm -rf ./lame-$VERSION
rm -rf ./lame-$VERSION-orig
