#!/bin/sh

VERSION=3.4-20140514

tar --files-from=file.list -xjvf ../linux-sunxi-$VERSION.tar.bz2
mv linux-sunxi-$VERSION linux-sunxi-$VERSION-orig

cp -rf ./linux-sunxi-$VERSION-new ./linux-sunxi-$VERSION

diff -b --unified -Nr  linux-sunxi-$VERSION-orig  linux-sunxi-$VERSION > linux-sunxi-$VERSION-a1x-vfp.patch

mv linux-sunxi-$VERSION-a1x-vfp.patch ../patches

rm -rf ./linux-sunxi-$VERSION
rm -rf ./linux-sunxi-$VERSION-orig
