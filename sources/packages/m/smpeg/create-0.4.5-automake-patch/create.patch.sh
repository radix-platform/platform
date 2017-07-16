#!/bin/sh

VERSION=0.4.5

tar --files-from=file.list -xzvf ../smpeg-$VERSION.tar.gz
mv smpeg-$VERSION smpeg-$VERSION-orig

cp -rf ./smpeg-$VERSION-new ./smpeg-$VERSION

diff -b --unified -Nr  smpeg-$VERSION-orig  smpeg-$VERSION > smpeg-$VERSION-automake.patch

mv smpeg-$VERSION-automake.patch ../patches

rm -rf ./smpeg-$VERSION
rm -rf ./smpeg-$VERSION-orig
