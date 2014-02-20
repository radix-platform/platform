#!/bin/sh

VERSION=3.8-6AJ.1.2-RC3

tar --files-from=file.list -xjvf ../linux-$VERSION.tar.bz2
mv linux-$VERSION linux-$VERSION-orig

cp -rf ./linux-$VERSION-new ./linux-$VERSION

diff -b --unified -Nr  linux-$VERSION-orig  linux-$VERSION > linux-$VERSION-hdmi.patch

mv linux-$VERSION-hdmi.patch ../patches

rm -rf ./linux-$VERSION
rm -rf ./linux-$VERSION-orig
