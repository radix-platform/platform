#!/bin/sh

VERSION=ol_r8.a8.10

tar --files-from=file.list -xjvf ../compat-wireless-$VERSION.tar.bz2
mv compat-wireless-$VERSION compat-wireless-$VERSION-orig

cp -rf ./compat-wireless-$VERSION-new ./compat-wireless-$VERSION

diff -b --unified -Nr  compat-wireless-$VERSION-orig  compat-wireless-$VERSION > compat-wireless-$VERSION-cross.patch

mv compat-wireless-$VERSION-cross.patch ../patches

rm -rf ./compat-wireless-$VERSION
rm -rf ./compat-wireless-$VERSION-orig
