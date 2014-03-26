#!/bin/sh

VERSION=18

tar --files-from=file.list -xzvf ../procinfo-$VERSION.tar.gz
mv procinfo-$VERSION procinfo-$VERSION-orig

cp -rf ./procinfo-$VERSION-new ./procinfo-$VERSION

diff -b --unified -Nr  procinfo-$VERSION-orig  procinfo-$VERSION > procinfo-$VERSION.patch

mv procinfo-$VERSION.patch ../patches

rm -rf ./procinfo-$VERSION
rm -rf ./procinfo-$VERSION-orig
