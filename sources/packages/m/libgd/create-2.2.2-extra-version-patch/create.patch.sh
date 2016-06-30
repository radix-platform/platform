#!/bin/sh

VERSION=2.2.2

tar --files-from=file.list -xJvf ../libgd-$VERSION.tar.xz
mv libgd-$VERSION libgd-$VERSION-orig

cp -rf ./libgd-$VERSION-new ./libgd-$VERSION

diff -b --unified -Nr  libgd-$VERSION-orig  libgd-$VERSION > libgd-$VERSION-extra-version.patch

mv libgd-$VERSION-extra-version.patch ../patches

rm -rf ./libgd-$VERSION
rm -rf ./libgd-$VERSION-orig
