#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../xf86dga-$VERSION.tar.bz2
mv xf86dga-$VERSION xf86dga-$VERSION-orig

cp -rf ./xf86dga-$VERSION-new ./xf86dga-$VERSION

diff -b --unified -Nr  xf86dga-$VERSION-orig  xf86dga-$VERSION > xf86dga-$VERSION-automake.patch

mv xf86dga-$VERSION-automake.patch ../patches

rm -rf ./xf86dga-$VERSION
rm -rf ./xf86dga-$VERSION-orig
