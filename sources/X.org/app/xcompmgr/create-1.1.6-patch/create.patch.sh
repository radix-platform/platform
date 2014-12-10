#!/bin/sh

VERSION=1.1.6

tar --files-from=file.list -xjvf ../xcompmgr-$VERSION.tar.bz2
mv xcompmgr-$VERSION xcompmgr-$VERSION-orig

cp -rf ./xcompmgr-$VERSION-new ./xcompmgr-$VERSION

diff -b --unified -Nr  xcompmgr-$VERSION-orig  xcompmgr-$VERSION > xcompmgr-$VERSION.patch

mv xcompmgr-$VERSION.patch ../patches

rm -rf ./xcompmgr-$VERSION
rm -rf ./xcompmgr-$VERSION-orig
