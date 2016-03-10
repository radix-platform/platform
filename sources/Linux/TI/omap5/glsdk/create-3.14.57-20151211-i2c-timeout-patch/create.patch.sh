#!/bin/sh

VERSION=3.14.57-20151211

tar --files-from=file.list -xJvf ../linux-glsdk-$VERSION.tar.xz
mv linux-glsdk-$VERSION linux-glsdk-$VERSION-orig

cp -rf ./linux-glsdk-$VERSION-new ./linux-glsdk-$VERSION

diff -b --unified -Nr  linux-glsdk-$VERSION-orig  linux-glsdk-$VERSION > linux-glsdk-$VERSION-i2c-timeout.patch

mv linux-glsdk-$VERSION-i2c-timeout.patch ../patches

rm -rf ./linux-glsdk-$VERSION
rm -rf ./linux-glsdk-$VERSION-orig
