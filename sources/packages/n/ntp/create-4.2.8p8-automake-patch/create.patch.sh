#!/bin/sh

VERSION=4.2.8p8

tar --files-from=file.list -xzvf ../ntp-$VERSION.tar.gz
mv ntp-$VERSION ntp-$VERSION-orig

cp -rf ./ntp-$VERSION-new ./ntp-$VERSION

diff -b --unified -Nr  ntp-$VERSION-orig  ntp-$VERSION > ntp-$VERSION-automake.patch

mv ntp-$VERSION-automake.patch ../patches

rm -rf ./ntp-$VERSION
rm -rf ./ntp-$VERSION-orig
