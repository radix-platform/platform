#!/bin/sh

VERSION=1.6.0

tar --files-from=file.list -xJvf ../openh264-$VERSION.tar.xz
mv openh264-$VERSION openh264-$VERSION-orig

cp -rf ./openh264-$VERSION-new ./openh264-$VERSION

diff -b --unified -Nr  openh264-$VERSION-orig  openh264-$VERSION > openh264-$VERSION-make.patch

mv openh264-$VERSION-make.patch ../patches

rm -rf ./openh264-$VERSION
rm -rf ./openh264-$VERSION-orig
