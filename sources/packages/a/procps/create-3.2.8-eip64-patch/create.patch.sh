#!/bin/sh

VERSION=3.2.8

tar -xzf ../procps-$VERSION.tar.gz
patch -p0 < ../patches/procps-$VERSION.patch
tar -czf ./procps-$VERSION.tar.gz procps-$VERSION
rm -rf procps-$VERSION

tar --files-from=file.list -xzvf ./procps-$VERSION.tar.gz
mv procps-$VERSION procps-$VERSION-orig

cp -rf ./procps-$VERSION-new ./procps-$VERSION

diff -b --unified -Nr  procps-$VERSION-orig  procps-$VERSION > procps-$VERSION-eip64.patch

mv procps-$VERSION-eip64.patch ../patches

rm -rf ./procps-$VERSION
rm -rf ./procps-$VERSION-orig
rm  -f ./procps-$VERSION.tar.gz
