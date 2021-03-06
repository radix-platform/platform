#!/bin/sh

VERSION=1.4.0

tar --files-from=file.list -xjvf ../libvpx-$VERSION.tar.bz2
mv libvpx-$VERSION libvpx-$VERSION-orig

cp -rf ./libvpx-$VERSION-new ./libvpx-$VERSION

diff -b --unified -Nr  libvpx-$VERSION-orig  libvpx-$VERSION > libvpx-$VERSION-arch.patch

mv libvpx-$VERSION-arch.patch ../patches

rm -rf ./libvpx-$VERSION
rm -rf ./libvpx-$VERSION-orig
