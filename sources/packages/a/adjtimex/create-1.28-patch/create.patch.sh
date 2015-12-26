#!/bin/sh

VERSION=1.28

tar --files-from=file.list -xzvf ../adjtimex-$VERSION.tar.gz
mv adjtimex-$VERSION adjtimex-$VERSION-orig

cp -rf ./adjtimex-$VERSION-new ./adjtimex-$VERSION

diff -b --unified -Nr  adjtimex-$VERSION-orig  adjtimex-$VERSION > adjtimex-$VERSION.patch

mv adjtimex-$VERSION.patch ../patches

rm -rf ./adjtimex-$VERSION
rm -rf ./adjtimex-$VERSION-orig

#
# Create 1.29 tarball
#
NEW_VERSION=1.29
tar -xzf ../adjtimex-$VERSION.tar.gz
cat ../patches/adjtimex-$VERSION.patch | patch -p0
mv adjtimex-$VERSION adjtimex-$NEW_VERSION
tar -czf ../adjtimex-$NEW_VERSION.tar.gz adjtimex-$NEW_VERSION
rm -rf adjtimex-$NEW_VERSION
