#!/bin/sh

VERSION=2.6.36

tar --files-from=file.list -xjvf ../linux-$VERSION.tar.bz2
mv linux-$VERSION linux-$VERSION-orig

cp -rf ./linux-$VERSION-new ./linux-$VERSION

diff -b --unified -Nr  linux-$VERSION-orig  linux-$VERSION > linux-$VERSION-xattr.patch

mv linux-$VERSION-xattr.patch ../patches

rm -rf ./linux-$VERSION
rm -rf ./linux-$VERSION-orig
