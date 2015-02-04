#!/bin/sh

VERSION=0.10.36

tar --files-from=file.list -xJvf ../gst-plugins-base-$VERSION.tar.xz
mv gst-plugins-base-$VERSION gst-plugins-base-$VERSION-orig

cp -rf ./gst-plugins-base-$VERSION-new ./gst-plugins-base-$VERSION

diff -b --unified -Nr  gst-plugins-base-$VERSION-orig  gst-plugins-base-$VERSION > gst-plugins-base-$VERSION.patch

mv gst-plugins-base-$VERSION.patch ../patches

rm -rf ./gst-plugins-base-$VERSION
rm -rf ./gst-plugins-base-$VERSION-orig
