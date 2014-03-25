#!/bin/sh

VERSION=3.0.26

tar --files-from=file.list -xJf ../dosfstools-$VERSION.tar.xz
mv dosfstools-$VERSION dosfstools-$VERSION-orig

cp -rf ./dosfstools-$VERSION-new ./dosfstools-$VERSION

diff -b --unified -Nr  dosfstools-$VERSION-orig  dosfstools-$VERSION > dosfstools-$VERSION.patch

mv dosfstools-$VERSION.patch ../patches

rm -rf ./dosfstools-$VERSION
rm -rf ./dosfstools-$VERSION-orig
