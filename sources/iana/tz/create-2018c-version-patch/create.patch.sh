#!/bin/sh

VERSION=2018c

mkdir -p timezone
tar -C timezone --files-from=file.list -xzvf ../tzcode$VERSION.tar.gz
mv timezone timezone-orig

cp -rf ./timezone-new ./timezone

diff -b --unified -Nr  timezone-orig  timezone > tzcode-$VERSION-version.patch

mv tzcode-$VERSION-version.patch ../patches

rm -rf ./timezone
rm -rf ./timezone-orig
