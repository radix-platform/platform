#!/bin/sh

VERSION=2.17

tar --files-from=file.list -xzvf ../bsd-games-$VERSION.tar.gz
mv bsd-games-$VERSION bsd-games-$VERSION-orig

cp -rf ./bsd-games-$VERSION-new ./bsd-games-$VERSION

diff -b --unified -Nr  bsd-games-$VERSION-orig  bsd-games-$VERSION > bsd-games-$VERSION.patch

mv bsd-games-$VERSION.patch ../patches

rm -rf ./bsd-games-$VERSION
rm -rf ./bsd-games-$VERSION-orig
