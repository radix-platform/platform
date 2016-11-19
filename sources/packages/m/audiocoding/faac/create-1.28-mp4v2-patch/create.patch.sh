#!/bin/sh

VERSION=1.28

tar --files-from=file.list -xzvf ../faac-$VERSION.tar.gz
mv faac-$VERSION faac-$VERSION-orig

cp -rf ./faac-$VERSION-new ./faac-$VERSION

diff -b --unified -Nr  faac-$VERSION-orig  faac-$VERSION > faac-$VERSION-mp4v2.patch

mv faac-$VERSION-mp4v2.patch ../patches

rm -rf ./faac-$VERSION
rm -rf ./faac-$VERSION-orig
