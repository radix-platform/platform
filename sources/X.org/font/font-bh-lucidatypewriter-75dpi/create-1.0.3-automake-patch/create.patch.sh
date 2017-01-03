#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../font-bh-lucidatypewriter-75dpi-$VERSION.tar.bz2
mv font-bh-lucidatypewriter-75dpi-$VERSION font-bh-lucidatypewriter-75dpi-$VERSION-orig

cp -rf ./font-bh-lucidatypewriter-75dpi-$VERSION-new ./font-bh-lucidatypewriter-75dpi-$VERSION

diff -b --unified -Nr  font-bh-lucidatypewriter-75dpi-$VERSION-orig  font-bh-lucidatypewriter-75dpi-$VERSION > font-bh-lucidatypewriter-75dpi-$VERSION-automake.patch

mv font-bh-lucidatypewriter-75dpi-$VERSION-automake.patch ../patches

rm -rf ./font-bh-lucidatypewriter-75dpi-$VERSION
rm -rf ./font-bh-lucidatypewriter-75dpi-$VERSION-orig
