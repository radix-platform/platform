#!/bin/sh

VERSION=2.0.304

tar --files-from=file.list -xjvf ../procinfo-ng-$VERSION.tar.bz2
mv procinfo-ng-$VERSION procinfo-ng-$VERSION-orig

cp -rf ./procinfo-ng-$VERSION-new ./procinfo-ng-$VERSION

diff -b --unified -Nr  procinfo-ng-$VERSION-orig  procinfo-ng-$VERSION > procinfo-ng-$VERSION-cross.patch

mv procinfo-ng-$VERSION-cross.patch ../patches

rm -rf ./procinfo-ng-$VERSION
rm -rf ./procinfo-ng-$VERSION-orig
