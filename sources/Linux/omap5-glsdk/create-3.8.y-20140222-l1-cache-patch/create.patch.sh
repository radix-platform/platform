#!/bin/sh

VERSION=3.8.y-20140222

tar --files-from=file.list -xjvf ../linux-glsdk-$VERSION.tar.bz2
mv linux-glsdk-$VERSION linux-glsdk-$VERSION-orig

cp -rf ./linux-glsdk-$VERSION-new ./linux-glsdk-$VERSION

diff -b --unified -Nr  linux-glsdk-$VERSION-orig  linux-glsdk-$VERSION > linux-glsdk-$VERSION-l1-cache.patch

mv linux-glsdk-$VERSION-l1-cache.patch ../patches

rm -rf ./linux-glsdk-$VERSION
rm -rf ./linux-glsdk-$VERSION-orig
