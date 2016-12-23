#!/bin/sh

VERSION=0.5.3

tar --files-from=file.list -xjvf ../xcm-$VERSION.tar.bz2
mv xcm-$VERSION xcm-$VERSION-orig

cp -rf ./xcm-$VERSION-new ./xcm-$VERSION

diff -b --unified -Nr  xcm-$VERSION-orig  xcm-$VERSION > xcm-$VERSION-automake.patch

mv xcm-$VERSION-automake.patch ../patches

rm -rf ./xcm-$VERSION
rm -rf ./xcm-$VERSION-orig
