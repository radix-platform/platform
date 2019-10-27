#!/bin/sh

VERSION=3.3.15

tar --files-from=file.list -xJvf ../procps-ng-$VERSION.tar.xz
mv procps-ng-$VERSION procps-ng-$VERSION-orig

cp -rf ./procps-ng-$VERSION-new ./procps-ng-$VERSION

diff -b --unified -Nr  procps-ng-$VERSION-orig  procps-ng-$VERSION > procps-ng-$VERSION-rpl-malloc.patch

mv procps-ng-$VERSION-rpl-malloc.patch ../patches

rm -rf ./procps-ng-$VERSION
rm -rf ./procps-ng-$VERSION-orig
