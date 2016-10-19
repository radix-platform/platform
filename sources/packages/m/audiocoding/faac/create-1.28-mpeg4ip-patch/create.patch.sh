#!/bin/sh

VERSION=1.28

tar --files-from=file.list -xzvf ../faac-$VERSION.tar.gz
mv faac-$VERSION faac-$VERSION-orig

cp -rf ./faac-$VERSION-new ./faac-$VERSION

diff -b --unified -Nr  faac-$VERSION-orig  faac-$VERSION > faac-$VERSION-mpeg4ip.patch

mv faac-$VERSION-mpeg4ip.patch ../patches

rm -rf ./faac-$VERSION
rm -rf ./faac-$VERSION-orig
