#!/bin/sh

VERSION=1.0

tar --files-from=file.list -xzvf ../idnkit-$VERSION-src.tar.gz
mv idnkit-$VERSION-src idnkit-$VERSION-src-orig

cp -rf ./idnkit-$VERSION-src-new ./idnkit-$VERSION-src

diff -b --unified -Nr  idnkit-$VERSION-src-orig  idnkit-$VERSION-src > idnkit-$VERSION-automake.patch

mv idnkit-$VERSION-automake.patch ../patches

rm -rf ./idnkit-$VERSION-src
rm -rf ./idnkit-$VERSION-src-orig
