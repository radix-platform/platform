#!/bin/sh

VERSION=0.14

tar --files-from=file.list -xzvf ../libdaemon-$VERSION.tar.gz
mv libdaemon-$VERSION libdaemon-$VERSION-orig

cp -rf ./libdaemon-$VERSION-new ./libdaemon-$VERSION

diff -b --unified -Nr  libdaemon-$VERSION-orig  libdaemon-$VERSION > libdaemon-$VERSION-automake.patch

mv libdaemon-$VERSION-automake.patch ../patches

rm -rf ./libdaemon-$VERSION
rm -rf ./libdaemon-$VERSION-orig
