#!/bin/sh

VERSION=1.0.2f

tar --files-from=file.list -xzvf ../openssl-$VERSION.tar.gz
mv openssl-$VERSION openssl-$VERSION-orig

cp -rf ./openssl-$VERSION-new ./openssl-$VERSION

diff -b --unified -Nr  openssl-$VERSION-orig  openssl-$VERSION > openssl-$VERSION-mips-O2.patch

mv openssl-$VERSION-mips-O2.patch ../patches

rm -rf ./openssl-$VERSION
rm -rf ./openssl-$VERSION-orig
