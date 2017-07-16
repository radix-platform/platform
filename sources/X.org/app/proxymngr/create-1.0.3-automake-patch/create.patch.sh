#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../proxymngr-$VERSION.tar.bz2
mv proxymngr-$VERSION proxymngr-$VERSION-orig

cp -rf ./proxymngr-$VERSION-new ./proxymngr-$VERSION

diff -b --unified -Nr  proxymngr-$VERSION-orig  proxymngr-$VERSION > proxymngr-$VERSION-automake.patch

mv proxymngr-$VERSION-automake.patch ../patches

rm -rf ./proxymngr-$VERSION
rm -rf ./proxymngr-$VERSION-orig
