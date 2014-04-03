#!/bin/sh

VERSION=1.0.1f

tar --files-from=file.list -xzf ../openssl-$VERSION.tar.gz
mv openssl-$VERSION openssl-$VERSION-orig

cp -rf ./openssl-$VERSION-new ./openssl-$VERSION

diff -b --unified -Nr  openssl-$VERSION-orig  openssl-$VERSION > openssl-$VERSION-pod.patch

mv openssl-$VERSION-pod.patch ../patches

rm -rf ./openssl-$VERSION
rm -rf ./openssl-$VERSION-orig
