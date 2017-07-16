#!/bin/sh

VERSION=1.0.2

tar --files-from=file.list -xjvf ../font-bitstream-speedo-$VERSION.tar.bz2
mv font-bitstream-speedo-$VERSION font-bitstream-speedo-$VERSION-orig

cp -rf ./font-bitstream-speedo-$VERSION-new ./font-bitstream-speedo-$VERSION

diff -b --unified -Nr  font-bitstream-speedo-$VERSION-orig  font-bitstream-speedo-$VERSION > font-bitstream-speedo-$VERSION-automake.patch

mv font-bitstream-speedo-$VERSION-automake.patch ../patches

rm -rf ./font-bitstream-speedo-$VERSION
rm -rf ./font-bitstream-speedo-$VERSION-orig
