#!/bin/sh

VERSION=1.11

tar --files-from=file.list -xzf ../icmpinfo-$VERSION.tar.gz
mv icmpinfo-$VERSION icmpinfo-$VERSION-orig

cp -rf ./icmpinfo-$VERSION-new ./icmpinfo-$VERSION

diff -b --unified -Nr  icmpinfo-$VERSION-orig  icmpinfo-$VERSION > icmpinfo-$VERSION.patch

mv icmpinfo-$VERSION.patch ../patches

rm -rf ./icmpinfo-$VERSION
rm -rf ./icmpinfo-$VERSION-orig
