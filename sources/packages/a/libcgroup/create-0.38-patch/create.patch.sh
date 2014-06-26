#!/bin/sh

VERSION=0.38

tar --files-from=file.list -xjvf ../libcgroup-$VERSION.tar.bz2
mv libcgroup-$VERSION libcgroup-$VERSION-orig

cp -rf ./libcgroup-$VERSION-new ./libcgroup-$VERSION

diff -b --unified -Nr  libcgroup-$VERSION-orig libcgroup-$VERSION > libcgroup-$VERSION.patch

mv libcgroup-$VERSION.patch ../patches

rm -rf ./libcgroup-$VERSION
rm -rf ./libcgroup-$VERSION-orig
