#!/bin/sh

VERSION=2.3.21

tar --files-from=file.list -xzvf ../libart_lgpl-$VERSION.tar.gz
mv libart_lgpl-$VERSION libart_lgpl-$VERSION-orig

cp -rf ./libart_lgpl-$VERSION-new ./libart_lgpl-$VERSION

diff -b --unified -Nr  libart_lgpl-$VERSION-orig  libart_lgpl-$VERSION > libart_lgpl-$VERSION-automake.patch

mv libart_lgpl-$VERSION-automake.patch ../patches

rm -rf ./libart_lgpl-$VERSION
rm -rf ./libart_lgpl-$VERSION-orig
