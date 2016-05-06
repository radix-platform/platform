#!/bin/sh

VERSION=3.4.0

tar --files-from=file.list -xjvf ../lm_sensors-$VERSION.tar.bz2
mv lm_sensors-$VERSION lm_sensors-$VERSION-orig

cp -rf ./lm_sensors-$VERSION-new ./lm_sensors-$VERSION

diff -b --unified -Nr  lm_sensors-$VERSION-orig  lm_sensors-$VERSION > lm_sensors-$VERSION.patch

mv lm_sensors-$VERSION.patch ../patches

rm -rf ./lm_sensors-$VERSION
rm -rf ./lm_sensors-$VERSION-orig
