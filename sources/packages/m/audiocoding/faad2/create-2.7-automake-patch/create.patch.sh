#!/bin/sh

VERSION=2.7

tar --files-from=file.list -xzvf ../faad2-$VERSION.tar.gz
mv faad2-$VERSION faad2-$VERSION-orig

cp -rf ./faad2-$VERSION-new ./faad2-$VERSION

diff -b --unified -Nr  faad2-$VERSION-orig  faad2-$VERSION > faad2-$VERSION-automake.patch

mv faad2-$VERSION-automake.patch ../patches

rm -rf ./faad2-$VERSION
rm -rf ./faad2-$VERSION-orig
