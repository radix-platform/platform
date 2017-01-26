#!/bin/sh

VERSION=0.4.2

tar --files-from=file.list -xzvf ../xf86-video-mali-$VERSION.tar.gz
mv xf86-video-mali-$VERSION xf86-video-mali-$VERSION-orig

cp -rf ./xf86-video-mali-$VERSION-new ./xf86-video-mali-$VERSION

diff -b --unified -Nr  xf86-video-mali-$VERSION-orig  xf86-video-mali-$VERSION > xf86-video-mali-$VERSION-no-ump.patch

mv xf86-video-mali-$VERSION-no-ump.patch ../patches

rm -rf ./xf86-video-mali-$VERSION
rm -rf ./xf86-video-mali-$VERSION-orig
