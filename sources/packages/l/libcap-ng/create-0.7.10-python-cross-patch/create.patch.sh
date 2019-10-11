#!/bin/sh

VERSION=0.7.10

tar --files-from=file.list -xJvf ../libcap-ng-$VERSION.tar.xz
mv libcap-ng-$VERSION libcap-ng-$VERSION-orig

cp -rf ./libcap-ng-$VERSION-new ./libcap-ng-$VERSION

diff -b --unified -Nr  libcap-ng-$VERSION-orig  libcap-ng-$VERSION > libcap-ng-$VERSION-python-cross.patch

mv libcap-ng-$VERSION-python-cross.patch ../patches

rm -rf ./libcap-ng-$VERSION
rm -rf ./libcap-ng-$VERSION-orig
