#!/bin/sh

VERSION=0.10.36

tar --files-from=file.list -xJvf ../gstreamer-ti-$VERSION.tar.xz
mv gstreamer-ti-$VERSION gstreamer-ti-$VERSION-orig

cp -rf ./gstreamer-ti-$VERSION-new ./gstreamer-ti-$VERSION

diff -b --unified -Nr  gstreamer-ti-$VERSION-orig  gstreamer-ti-$VERSION > gstreamer-ti-$VERSION-remove-osx-test.patch

mv gstreamer-ti-$VERSION-remove-osx-test.patch ../patches

rm -rf ./gstreamer-ti-$VERSION
rm -rf ./gstreamer-ti-$VERSION-orig
