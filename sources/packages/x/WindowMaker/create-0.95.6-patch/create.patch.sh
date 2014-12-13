#!/bin/sh

VERSION=0.95.6

tar --files-from=file.list -xzvf ../WindowMaker-$VERSION.tar.gz
mv WindowMaker-$VERSION WindowMaker-$VERSION-orig

cp -rf ./WindowMaker-$VERSION-new ./WindowMaker-$VERSION

diff -b --unified -Nr  WindowMaker-$VERSION-orig  WindowMaker-$VERSION > WindowMaker-$VERSION.patch

mv WindowMaker-$VERSION.patch ../patches

rm -rf ./WindowMaker-$VERSION
rm -rf ./WindowMaker-$VERSION-orig
