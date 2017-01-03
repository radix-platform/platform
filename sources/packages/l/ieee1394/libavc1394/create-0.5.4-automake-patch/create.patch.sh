#!/bin/sh

VERSION=0.5.4

tar --files-from=file.list -xzvf ../libavc1394-$VERSION.tar.gz
mv libavc1394-$VERSION libavc1394-$VERSION-orig

cp -rf ./libavc1394-$VERSION-new ./libavc1394-$VERSION

diff -b --unified -Nr  libavc1394-$VERSION-orig  libavc1394-$VERSION > libavc1394-$VERSION-automake.patch

mv libavc1394-$VERSION-automake.patch ../patches

rm -rf ./libavc1394-$VERSION
rm -rf ./libavc1394-$VERSION-orig
