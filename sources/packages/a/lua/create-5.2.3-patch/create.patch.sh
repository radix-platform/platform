#!/bin/sh

VERSION=5.2.3

tar --files-from=file.list -xzvf ../lua-$VERSION.tar.gz
mv lua-$VERSION lua-$VERSION-orig

cp -rf ./lua-$VERSION-new ./lua-$VERSION

diff -b --unified -Nr  lua-$VERSION-orig  lua-$VERSION > lua-$VERSION.patch

mv lua-$VERSION.patch ../patches

rm -rf ./lua-$VERSION
rm -rf ./lua-$VERSION-orig
