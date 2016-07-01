#!/bin/sh

VERSION=3.16.5

tar --files-from=file.list -xzvf ../hplip-$VERSION.tar.gz
mv hplip-$VERSION hplip-$VERSION-orig

cp -rf ./hplip-$VERSION-new ./hplip-$VERSION

diff --unified -Nr  hplip-$VERSION-orig  hplip-$VERSION > hplip-$VERSION-lc-all-c.patch

mv hplip-$VERSION-lc-all-c.patch ../patches

rm -rf ./hplip-$VERSION
rm -rf ./hplip-$VERSION-orig
