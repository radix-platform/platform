#!/bin/sh

VERSION=1.1.15

tar --files-from=file.list -xzf ../jfsutils-$VERSION.tar.gz
mv jfsutils-$VERSION jfsutils-$VERSION-orig

cp -rf ./jfsutils-$VERSION-new ./jfsutils-$VERSION

diff -b --unified -Nr  jfsutils-$VERSION-orig  jfsutils-$VERSION > jfsutils-$VERSION.patch

mv jfsutils-$VERSION.patch ../patches

rm -rf ./jfsutils-$VERSION
rm -rf ./jfsutils-$VERSION-orig
