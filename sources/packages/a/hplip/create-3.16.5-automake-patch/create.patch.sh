#!/bin/sh

VERSION=3.16.5

tar --files-from=file.list -xzvf ../hplip-$VERSION.tar.gz
mv hplip-$VERSION hplip-$VERSION-orig

cp -rf ./hplip-$VERSION-new ./hplip-$VERSION

diff -b --unified -Nr  hplip-$VERSION-orig  hplip-$VERSION > hplip-$VERSION-automake.patch

mv hplip-$VERSION-automake.patch ../patches

rm -rf ./hplip-$VERSION
rm -rf ./hplip-$VERSION-orig
