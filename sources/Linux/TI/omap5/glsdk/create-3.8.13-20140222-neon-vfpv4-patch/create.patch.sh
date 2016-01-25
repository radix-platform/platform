#!/bin/sh

VERSION=3.8.13-20140222

tar --files-from=file.list -xJvf ../linux-glsdk-$VERSION.tar.xz
mv linux-glsdk-$VERSION linux-glsdk-$VERSION-orig

cp -rf ./linux-glsdk-$VERSION-new ./linux-glsdk-$VERSION

diff -b --unified -Nr  linux-glsdk-$VERSION-orig  linux-glsdk-$VERSION > linux-glsdk-$VERSION-neon-vfpv4.patch

mv linux-glsdk-$VERSION-neon-vfpv4.patch ../patches

rm -rf ./linux-glsdk-$VERSION
rm -rf ./linux-glsdk-$VERSION-orig
