#!/bin/sh

VERSION=20190110

tar --files-from=file.list -xJvf ../ca-certificates_$VERSION.tar.xz
mv ca-certificates-$VERSION ca-certificates-$VERSION-orig

cp -rf ./ca-certificates-$VERSION-new ./ca-certificates-$VERSION

diff -b --unified -Nr  ca-certificates-$VERSION-orig  ca-certificates-$VERSION > ca-certificates-$VERSION-makefiles.patch

mv ca-certificates-$VERSION-makefiles.patch ../patches

rm -rf ./ca-certificates-$VERSION
rm -rf ./ca-certificates-$VERSION-orig
