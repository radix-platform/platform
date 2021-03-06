#!/bin/sh

VERSION=3.15.9

tar --files-from=file.list -xzvf ../hplip-$VERSION.tar.gz
mv hplip-$VERSION hplip-$VERSION-orig

cp -rf ./hplip-$VERSION-new ./hplip-$VERSION

diff -b --unified -Nr  hplip-$VERSION-orig  hplip-$VERSION > hplip-$VERSION-configure.patch

mv hplip-$VERSION-configure.patch ../patches

rm -rf ./hplip-$VERSION
rm -rf ./hplip-$VERSION-orig
