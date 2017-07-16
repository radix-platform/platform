#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../font-bitstream-75dpi-$VERSION.tar.bz2
mv font-bitstream-75dpi-$VERSION font-bitstream-75dpi-$VERSION-orig

cp -rf ./font-bitstream-75dpi-$VERSION-new ./font-bitstream-75dpi-$VERSION

diff -b --unified -Nr  font-bitstream-75dpi-$VERSION-orig  font-bitstream-75dpi-$VERSION > font-bitstream-75dpi-$VERSION-automake.patch

mv font-bitstream-75dpi-$VERSION-automake.patch ../patches

rm -rf ./font-bitstream-75dpi-$VERSION
rm -rf ./font-bitstream-75dpi-$VERSION-orig
