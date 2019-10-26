#!/bin/sh

VERSION=5.3

tar --files-from=file.list -xJvf ../btrfs-progs-$VERSION.tar.xz
mv btrfs-progs-$VERSION btrfs-progs-$VERSION-orig

cp -rf ./btrfs-progs-$VERSION-new ./btrfs-progs-$VERSION

diff -b --unified -Nr  btrfs-progs-$VERSION-orig  btrfs-progs-$VERSION > btrfs-progs-$VERSION-python-cross.patch

mv btrfs-progs-$VERSION-python-cross.patch ../patches

rm -rf ./btrfs-progs-$VERSION
rm -rf ./btrfs-progs-$VERSION-orig
