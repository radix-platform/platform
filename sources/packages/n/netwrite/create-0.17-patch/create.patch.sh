#!/bin/sh

VERSION=0.17

tar --files-from=file.list -xzf ../netwrite-$VERSION.tar.gz
mv netwrite-$VERSION netwrite-$VERSION-orig

cp -rf ./netwrite-$VERSION-new ./netwrite-$VERSION

diff -b --unified -Nr  netwrite-$VERSION-orig  netwrite-$VERSION > netwrite-$VERSION.patch

mv netwrite-$VERSION.patch ../patches

rm -rf ./netwrite-$VERSION
rm -rf ./netwrite-$VERSION-orig
