#!/bin/sh

VERSION=1.60-20140218

tar --files-from=file.list -xjf ../net-tools-$VERSION.tar.bz2
mv net-tools-$VERSION net-tools-$VERSION-orig

cp -rf ./net-tools-$VERSION-new ./net-tools-$VERSION

diff -b --unified -Nr  net-tools-$VERSION-orig  net-tools-$VERSION > net-tools-$VERSION.patch

mv net-tools-$VERSION.patch ../patches

rm -rf ./net-tools-$VERSION
rm -rf ./net-tools-$VERSION-orig
