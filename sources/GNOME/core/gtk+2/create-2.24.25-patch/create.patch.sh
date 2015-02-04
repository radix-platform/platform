#!/bin/sh

VERSION=2.24.25

tar --files-from=file.list -xJvf ../gtk+-$VERSION.tar.xz
mv gtk+-$VERSION gtk+-$VERSION-orig

cp -rf ./gtk+-$VERSION-new ./gtk+-$VERSION

diff -b --unified -Nr  gtk+-$VERSION-orig  gtk+-$VERSION > gtk+-$VERSION.patch

mv gtk+-$VERSION.patch ../patches

rm -rf ./gtk+-$VERSION
rm -rf ./gtk+-$VERSION-orig
