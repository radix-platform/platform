#!/bin/sh

VERSION=0.10.36

tar --files-from=file.list -xJvf ../gstreamer-$VERSION.tar.xz
mv gstreamer-$VERSION gstreamer-$VERSION-orig

cp -rf ./gstreamer-$VERSION-new ./gstreamer-$VERSION

diff -b --unified -Nr  gstreamer-$VERSION-orig  gstreamer-$VERSION > gstreamer-$VERSION-remove-osx-test.patch

mv gstreamer-$VERSION-remove-osx-test.patch ../patches

rm -rf ./gstreamer-$VERSION
rm -rf ./gstreamer-$VERSION-orig
