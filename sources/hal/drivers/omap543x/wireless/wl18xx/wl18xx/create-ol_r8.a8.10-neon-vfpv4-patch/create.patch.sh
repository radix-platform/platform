#!/bin/sh

VERSION=ol_r8.a8.10

tar --files-from=file.list -xjvf ../wl18xx-$VERSION.tar.bz2
mv wl18xx-$VERSION wl18xx-$VERSION-orig

cp -rf ./wl18xx-$VERSION-new ./wl18xx-$VERSION

diff -b --unified -Nr  wl18xx-$VERSION-orig  wl18xx-$VERSION > wl18xx-$VERSION-neon-vfpv4.patch

mv wl18xx-$VERSION-neon-vfpv4.patch ../patches

rm -rf ./wl18xx-$VERSION
rm -rf ./wl18xx-$VERSION-orig
