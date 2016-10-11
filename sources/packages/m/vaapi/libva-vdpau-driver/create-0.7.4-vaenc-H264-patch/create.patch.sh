#!/bin/sh

VERSION=0.7.4

tar --files-from=file.list -xjvf ../libva-vdpau-driver-$VERSION.tar.bz2
mv libva-vdpau-driver-$VERSION libva-vdpau-driver-$VERSION-orig

cp -rf ./libva-vdpau-driver-$VERSION-new ./libva-vdpau-driver-$VERSION

diff -b --unified -Nr  libva-vdpau-driver-$VERSION-orig  libva-vdpau-driver-$VERSION > libva-vdpau-driver-$VERSION-vaenc-H264.patch

mv libva-vdpau-driver-$VERSION-vaenc-H264.patch ../patches

rm -rf ./libva-vdpau-driver-$VERSION
rm -rf ./libva-vdpau-driver-$VERSION-orig
