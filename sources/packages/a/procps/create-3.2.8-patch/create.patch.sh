#!/bin/sh

VERSION=3.2.8

tar --files-from=file.list -xzvf ../procps-$VERSION.tar.gz
mv procps-$VERSION procps-$VERSION-orig

cp -rf ./procps-$VERSION-new ./procps-$VERSION

diff -b --unified -Nr  procps-$VERSION-orig  procps-$VERSION > procps-$VERSION.patch

mv procps-$VERSION.patch ../patches

rm -rf ./procps-$VERSION
rm -rf ./procps-$VERSION-orig
