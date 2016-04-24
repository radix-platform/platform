#!/bin/sh

VERSION=1.1.1

tar --files-from=file.list -xjvf ../alsa-utils-$VERSION.tar.bz2
mv alsa-utils-$VERSION alsa-utils-$VERSION-orig

cp -rf ./alsa-utils-$VERSION-new ./alsa-utils-$VERSION

diff -b --unified -Nr  alsa-utils-$VERSION-orig  alsa-utils-$VERSION > alsa-utils-$VERSION.patch

mv alsa-utils-$VERSION.patch ../patches

rm -rf ./alsa-utils-$VERSION
rm -rf ./alsa-utils-$VERSION-orig
