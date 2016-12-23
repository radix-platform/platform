#!/bin/sh

VERSION=1.0.5

tar --files-from=file.list -xjvf ../beforelight-$VERSION.tar.bz2
mv beforelight-$VERSION beforelight-$VERSION-orig

cp -rf ./beforelight-$VERSION-new ./beforelight-$VERSION

diff -b --unified -Nr  beforelight-$VERSION-orig  beforelight-$VERSION > beforelight-$VERSION-automake.patch

mv beforelight-$VERSION-automake.patch ../patches

rm -rf ./beforelight-$VERSION
rm -rf ./beforelight-$VERSION-orig
