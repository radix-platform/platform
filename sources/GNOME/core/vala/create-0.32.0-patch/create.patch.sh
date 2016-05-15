#!/bin/sh

VERSION=0.32.0

tar --files-from=file.list -xJvf ../vala-$VERSION.tar.xz
mv vala-$VERSION vala-$VERSION-orig

cp -rf ./vala-$VERSION-new ./vala-$VERSION

diff -b --unified -Nr  vala-$VERSION-orig  vala-$VERSION > vala-$VERSION.patch

mv vala-$VERSION.patch ../patches

rm -rf ./vala-$VERSION
rm -rf ./vala-$VERSION-orig
