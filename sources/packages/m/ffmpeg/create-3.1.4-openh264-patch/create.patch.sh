#!/bin/sh

VERSION=3.1.4

tar --files-from=file.list -xJvf ../ffmpeg-$VERSION.tar.xz
mv ffmpeg-$VERSION ffmpeg-$VERSION-orig

cp -rf ./ffmpeg-$VERSION-new ./ffmpeg-$VERSION

diff -b --unified -Nr  ffmpeg-$VERSION-orig  ffmpeg-$VERSION > ffmpeg-$VERSION-openh264.patch

mv ffmpeg-$VERSION-openh264.patch ../patches

rm -rf ./ffmpeg-$VERSION
rm -rf ./ffmpeg-$VERSION-orig
