#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../font-bitstream-100dpi-$VERSION.tar.bz2
mv font-bitstream-100dpi-$VERSION font-bitstream-100dpi-$VERSION-orig

cp -rf ./font-bitstream-100dpi-$VERSION-new ./font-bitstream-100dpi-$VERSION

diff -b --unified -Nr  font-bitstream-100dpi-$VERSION-orig  font-bitstream-100dpi-$VERSION > font-bitstream-100dpi-$VERSION-automake.patch

mv font-bitstream-100dpi-$VERSION-automake.patch ../patches

rm -rf ./font-bitstream-100dpi-$VERSION
rm -rf ./font-bitstream-100dpi-$VERSION-orig
