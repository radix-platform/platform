#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../font-bitstream-type1-$VERSION.tar.bz2
mv font-bitstream-type1-$VERSION font-bitstream-type1-$VERSION-orig

cp -rf ./font-bitstream-type1-$VERSION-new ./font-bitstream-type1-$VERSION

diff -b --unified -Nr  font-bitstream-type1-$VERSION-orig  font-bitstream-type1-$VERSION > font-bitstream-type1-$VERSION-automake.patch

mv font-bitstream-type1-$VERSION-automake.patch ../patches

rm -rf ./font-bitstream-type1-$VERSION
rm -rf ./font-bitstream-type1-$VERSION-orig
