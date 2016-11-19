#!/bin/sh

VERSION=1.13

tar --files-from=file.list -xzvf ../ladspa-$VERSION.tar.gz
mv ladspa-$VERSION ladspa-$VERSION-orig

cp -rf ./ladspa-$VERSION-new ./ladspa-$VERSION

diff -b --unified -Nr  ladspa-$VERSION-orig  ladspa-$VERSION > ladspa-$VERSION-ladspa-path.patch

mv ladspa-$VERSION-ladspa-path.patch ../patches

rm -rf ./ladspa-$VERSION
rm -rf ./ladspa-$VERSION-orig
