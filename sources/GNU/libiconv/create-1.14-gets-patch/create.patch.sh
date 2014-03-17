#!/bin/sh

VERSION=1.14

tar --files-from=file.list -xzvf ../libiconv-$VERSION.tar.gz
mv libiconv-$VERSION libiconv-$VERSION-orig

cp -rf ./libiconv-$VERSION-new ./libiconv-$VERSION

diff -b --unified -Nr  libiconv-$VERSION-orig  libiconv-$VERSION > libiconv-$VERSION-gets-c89.patch

mv libiconv-$VERSION-gets-c89.patch ../patches

rm -rf ./libiconv-$VERSION
rm -rf ./libiconv-$VERSION-orig
