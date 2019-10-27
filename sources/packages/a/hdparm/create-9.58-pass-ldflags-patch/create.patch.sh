#!/bin/sh

VERSION=9.58

tar --files-from=file.list -xzvf ../hdparm-$VERSION.tar.gz
mv hdparm-$VERSION hdparm-$VERSION-orig

cp -rf ./hdparm-$VERSION-new ./hdparm-$VERSION

diff -b --unified -Nr  hdparm-$VERSION-orig  hdparm-$VERSION > hdparm-$VERSION-pass-ldflags.patch

mv hdparm-$VERSION-pass-ldflags.patch ../patches

rm -rf ./hdparm-$VERSION
rm -rf ./hdparm-$VERSION-orig
