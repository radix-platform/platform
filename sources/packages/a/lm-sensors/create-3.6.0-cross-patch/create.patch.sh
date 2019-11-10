#!/bin/sh

VERSION=3.6.0

tar --files-from=file.list -xJvf ../lm-sensors-$VERSION.tar.xz
mv lm-sensors-$VERSION lm-sensors-$VERSION-orig

cp -rf ./lm-sensors-$VERSION-new ./lm-sensors-$VERSION

diff -b --unified -Nr  lm-sensors-$VERSION-orig  lm-sensors-$VERSION > lm-sensors-$VERSION-cross.patch

mv lm-sensors-$VERSION-cross.patch ../patches

rm -rf ./lm-sensors-$VERSION
rm -rf ./lm-sensors-$VERSION-orig
