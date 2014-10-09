#!/bin/sh

VERSION=9.10.1

tar --files-from=file.list -xzvf ../bind-$VERSION.tar.gz
mv bind-$VERSION bind-$VERSION-orig

cp -rf ./bind-$VERSION-new ./bind-$VERSION

diff -b --unified -Nr  bind-$VERSION-orig  bind-$VERSION > bind-$VERSION.patch

mv bind-$VERSION.patch ../patches

rm -rf ./bind-$VERSION
rm -rf ./bind-$VERSION-orig
