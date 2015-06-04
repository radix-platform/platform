#!/bin/sh

VERSION=13.0.2

tar --files-from=file.list -xjvf ../xf86-video-vmware-$VERSION.tar.bz2
mv xf86-video-vmware-$VERSION xf86-video-vmware-$VERSION-orig

cp -rf ./xf86-video-vmware-$VERSION-new ./xf86-video-vmware-$VERSION

diff -b --unified -Nr  xf86-video-vmware-$VERSION-orig  xf86-video-vmware-$VERSION > xf86-video-vmware-$VERSION-xorg.patch

mv xf86-video-vmware-$VERSION-xorg.patch ../patches

rm -rf ./xf86-video-vmware-$VERSION
rm -rf ./xf86-video-vmware-$VERSION-orig
