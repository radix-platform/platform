#!/bin/sh

VERSION=1.0.5

tar --files-from=file.list -xzvf ../judy-$VERSION.tar.gz
mv judy-$VERSION judy-$VERSION-orig

cp -rf ./judy-$VERSION-new ./judy-$VERSION

diff -b --unified -Nr  judy-$VERSION-orig  judy-$VERSION > judy-$VERSION-automake.patch

mv judy-$VERSION-automake.patch ../patches

rm -rf ./judy-$VERSION
rm -rf ./judy-$VERSION-orig
