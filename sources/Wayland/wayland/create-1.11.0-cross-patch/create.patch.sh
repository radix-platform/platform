#!/bin/sh

VERSION=1.11.0

tar --files-from=file.list -xJvf ../wayland-$VERSION.tar.xz
mv wayland-$VERSION wayland-$VERSION-orig

cp -rf ./wayland-$VERSION-new ./wayland-$VERSION

diff -b --unified -Nr  wayland-$VERSION-orig  wayland-$VERSION > wayland-$VERSION-cross.patch

mv wayland-$VERSION-cross.patch ../patches

rm -rf ./wayland-$VERSION
rm -rf ./wayland-$VERSION-orig
