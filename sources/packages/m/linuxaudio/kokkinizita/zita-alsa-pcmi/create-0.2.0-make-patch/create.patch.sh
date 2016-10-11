#!/bin/sh

VERSION=0.2.0

tar --files-from=file.list -xjvf ../zita-alsa-pcmi-$VERSION.tar.bz2
mv zita-alsa-pcmi-$VERSION zita-alsa-pcmi-$VERSION-orig

cp -rf ./zita-alsa-pcmi-$VERSION-new ./zita-alsa-pcmi-$VERSION

diff -b --unified -Nr  zita-alsa-pcmi-$VERSION-orig  zita-alsa-pcmi-$VERSION > zita-alsa-pcmi-$VERSION-make.patch

mv zita-alsa-pcmi-$VERSION-make.patch ../patches

rm -rf ./zita-alsa-pcmi-$VERSION
rm -rf ./zita-alsa-pcmi-$VERSION-orig
