#!/bin/sh

VERSION=3.8.y-20131223

tar --files-from=file.list -xjvf ../linux-glsdk-$VERSION.tar.bz2
mv linux-glsdk-$VERSION linux-glsdk-$VERSION-orig

cp -rf ./linux-glsdk-$VERSION-new ./linux-glsdk-$VERSION

diff -b --unified -Nr  linux-glsdk-$VERSION-orig  linux-glsdk-$VERSION > linux-glsdk-$VERSION-memset.patch

mv linux-glsdk-$VERSION-memset.patch ../patches

rm -rf ./linux-glsdk-$VERSION
rm -rf ./linux-glsdk-$VERSION-orig
