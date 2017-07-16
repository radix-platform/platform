#!/bin/sh

VERSION=2.1.0

tar --files-from=file.list -xzvf ../sysfsutils-$VERSION.tar.gz
mv sysfsutils-$VERSION sysfsutils-$VERSION-orig

cp -rf ./sysfsutils-$VERSION-new ./sysfsutils-$VERSION

diff -b --unified -Nr  sysfsutils-$VERSION-orig  sysfsutils-$VERSION > sysfsutils-$VERSION-automake.patch

mv sysfsutils-$VERSION-automake.patch ../patches

rm -rf ./sysfsutils-$VERSION
rm -rf ./sysfsutils-$VERSION-orig
