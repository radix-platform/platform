#!/bin/sh

VERSION=2.7

tar --files-from=file.list -xzvf ../lcms2-$VERSION.tar.gz
mv lcms2-$VERSION lcms2-$VERSION-orig

cp -rf ./lcms2-$VERSION-new ./lcms2-$VERSION

diff -b --unified -Nr  lcms2-$VERSION-orig  lcms2-$VERSION > lcms2-$VERSION-automake.patch

mv lcms2-$VERSION-automake.patch ../patches

rm -rf ./lcms2-$VERSION
rm -rf ./lcms2-$VERSION-orig
