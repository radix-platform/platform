#!/bin/sh

VERSION=2.2.51

tar --files-from=file.list -xzvf ../acl-$VERSION.src.tar.gz
mv acl-$VERSION acl-$VERSION-orig

cp -rf ./acl-$VERSION-new ./acl-$VERSION

diff -b --unified -Nr  acl-$VERSION-orig  acl-$VERSION > acl-$VERSION.patch

mv acl-$VERSION.patch ../patches

rm -rf ./acl-$VERSION
rm -rf ./acl-$VERSION-orig
