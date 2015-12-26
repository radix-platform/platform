#!/bin/sh

VERSION=1.29

tar --files-from=file.list -xzvf ../adjtimex-$VERSION.tar.gz
mv adjtimex-$VERSION adjtimex-$VERSION-orig

cp -rf ./adjtimex-$VERSION-new ./adjtimex-$VERSION

diff -b --unified -Nr  adjtimex-$VERSION-orig  adjtimex-$VERSION > adjtimex-$VERSION.patch

mv adjtimex-$VERSION.patch ../patches

rm -rf ./adjtimex-$VERSION
rm -rf ./adjtimex-$VERSION-orig
