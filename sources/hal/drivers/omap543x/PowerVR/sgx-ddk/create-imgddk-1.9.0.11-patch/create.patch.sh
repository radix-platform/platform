#!/bin/sh

VERSION=1.9.0.11

tar --files-from=file.list -xjvf ../ti_imgddk_$VERSION.tar.bz2
mv ti_imgddk_$VERSION ti_imgddk_$VERSION-orig

cp -rf ./ti_imgddk_$VERSION-new ./ti_imgddk_$VERSION

diff -b --unified -Nr  ti_imgddk_$VERSION-orig  ti_imgddk_$VERSION > fix-dos2unix.patch

mv fix-dos2unix.patch ../patches

rm -rf ./ti_imgddk_$VERSION
rm -rf ./ti_imgddk_$VERSION-orig
