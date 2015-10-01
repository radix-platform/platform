#!/bin/sh

VERSION=2.1.1

tar --files-from=file.list -xJvf ../libgd-$VERSION.tar.xz
mv libgd-$VERSION libgd-$VERSION-orig

cp -rf ./libgd-$VERSION-new ./libgd-$VERSION

diff -b --unified -Nr  libgd-$VERSION-orig  libgd-$VERSION > libgd-$VERSION-libvpx-1.4.0.patch

mv libgd-$VERSION-libvpx-1.4.0.patch ../patches

rm -rf ./libgd-$VERSION
rm -rf ./libgd-$VERSION-orig
