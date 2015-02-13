#!/bin/sh

VERSION=1.4.0

tar --files-from=file.list -xzvf ../aalib-1.4rc5.tar.gz
mv aalib-$VERSION aalib-$VERSION-orig

cp -rf ./aalib-$VERSION-new ./aalib-$VERSION

diff -b --unified -Nr  aalib-$VERSION-orig  aalib-$VERSION > aalib-$VERSION.patch

mv aalib-$VERSION.patch ../patches

rm -rf ./aalib-$VERSION
rm -rf ./aalib-$VERSION-orig
