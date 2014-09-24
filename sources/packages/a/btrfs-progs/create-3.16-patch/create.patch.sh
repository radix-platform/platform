#!/bin/sh

VERSION=3.16

tar --files-from=file.list -xjvf ../btrfs-progs-$VERSION.tar.bz2
mv btrfs-progs-$VERSION btrfs-progs-$VERSION-orig

cp -rf ./btrfs-progs-$VERSION-new ./btrfs-progs-$VERSION

diff -b --unified -Nr  btrfs-progs-$VERSION-orig  btrfs-progs-$VERSION > btrfs-progs-$VERSION.patch

mv btrfs-progs-$VERSION.patch ../patches

rm -rf ./btrfs-progs-$VERSION
rm -rf ./btrfs-progs-$VERSION-orig
