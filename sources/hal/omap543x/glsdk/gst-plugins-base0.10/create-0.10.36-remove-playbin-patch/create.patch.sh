#!/bin/sh

VERSION=0.10.36

tar --files-from=file.list -xJvf ../gst-plugins-base-ti-$VERSION.tar.xz
mv gst-plugins-base-ti-$VERSION gst-plugins-base-ti-$VERSION-orig

cp -rf ./gst-plugins-base-ti-$VERSION-new ./gst-plugins-base-ti-$VERSION

diff -b --unified -Nr  gst-plugins-base-ti-$VERSION-orig  gst-plugins-base-ti-$VERSION > gst-plugins-base-ti-$VERSION-remove-playbin.patch

mv gst-plugins-base-ti-$VERSION-remove-playbin.patch ../patches

rm -rf ./gst-plugins-base-ti-$VERSION
rm -rf ./gst-plugins-base-ti-$VERSION-orig
