#!/bin/sh

VERSION=0.2.0

tar --files-from=file.list -xjvf ../xf86-video-v4l-$VERSION.tar.bz2
mv xf86-video-v4l-$VERSION xf86-video-v4l-$VERSION-orig

cp -rf ./xf86-video-v4l-$VERSION-new ./xf86-video-v4l-$VERSION

diff -b --unified -Nr  xf86-video-v4l-$VERSION-orig  xf86-video-v4l-$VERSION > xf86-video-v4l-$VERSION-build.patch

mv xf86-video-v4l-$VERSION-build.patch ../patches

rm -rf ./xf86-video-v4l-$VERSION
rm -rf ./xf86-video-v4l-$VERSION-orig
