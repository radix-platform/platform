#!/bin/sh

VERSION=2.25

tar --files-from=file.list -xJvf ../libcap-$VERSION.tar.xz
mv libcap-$VERSION libcap-$VERSION-orig

cp -rf ./libcap-$VERSION-new ./libcap-$VERSION

diff -b --unified -Nr  libcap-$VERSION-orig  libcap-$VERSION > libcap-$VERSION-gperf-output.patch

mv libcap-$VERSION-gperf-output.patch ../patches

rm -rf ./libcap-$VERSION
rm -rf ./libcap-$VERSION-orig
