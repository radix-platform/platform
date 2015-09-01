#!/bin/sh

VERSION=3.0.8-20150728

tar --files-from=file.list -xjvf ../linux-ci20-$VERSION.tar.bz2
mv linux-ci20-$VERSION linux-ci20-$VERSION-orig

cp -rf ./linux-ci20-$VERSION-new ./linux-ci20-$VERSION

diff -b --unified -Nr  linux-ci20-$VERSION-orig  linux-ci20-$VERSION > linux-ci20-$VERSION-ppp.patch

mv linux-ci20-$VERSION-ppp.patch ../patches

rm -rf ./linux-ci20-$VERSION
rm -rf ./linux-ci20-$VERSION-orig
