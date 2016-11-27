#!/bin/sh

VERSION=2.2.4

tar --files-from=file.list -xjvf ../slang-$VERSION.tar.bz2
mv slang-$VERSION slang-$VERSION-orig

cp -rf ./slang-$VERSION-new ./slang-$VERSION

diff -b --unified -Nr  slang-$VERSION-orig  slang-$VERSION > slang-$VERSION-automake.patch

mv slang-$VERSION-automake.patch ../patches

rm -rf ./slang-$VERSION
rm -rf ./slang-$VERSION-orig
