#!/bin/sh

VERSION=1.4.0

tar --files-from=file.list -xzvf ../vorbis-tools-$VERSION.tar.gz
mv vorbis-tools-$VERSION vorbis-tools-$VERSION-orig

cp -rf ./vorbis-tools-$VERSION-new ./vorbis-tools-$VERSION

diff -b --unified -Nr  vorbis-tools-$VERSION-orig  vorbis-tools-$VERSION > vorbis-tools-$VERSION-automake.patch

mv vorbis-tools-$VERSION-automake.patch ../patches

rm -rf ./vorbis-tools-$VERSION
rm -rf ./vorbis-tools-$VERSION-orig
