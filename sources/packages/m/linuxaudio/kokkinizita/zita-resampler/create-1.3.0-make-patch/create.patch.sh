#!/bin/sh

VERSION=1.3.0

tar --files-from=file.list -xjvf ../zita-resampler-$VERSION.tar.bz2
mv zita-resampler-$VERSION zita-resampler-$VERSION-orig

cp -rf ./zita-resampler-$VERSION-new ./zita-resampler-$VERSION

diff -b --unified -Nr  zita-resampler-$VERSION-orig  zita-resampler-$VERSION > zita-resampler-$VERSION-make.patch

mv zita-resampler-$VERSION-make.patch ../patches

rm -rf ./zita-resampler-$VERSION
rm -rf ./zita-resampler-$VERSION-orig
