#!/bin/sh

VERSION=1.0.24

tar --files-from=file.list -xjvf ../sane-backends-$VERSION.tar.bz2
mv sane-backends-$VERSION sane-backends-$VERSION-orig

cp -rf ./sane-backends-$VERSION-new ./sane-backends-$VERSION

diff -b --unified -Nr  sane-backends-$VERSION-orig  sane-backends-$VERSION > sane-backends-$VERSION-sane-settable.patch

mv sane-backends-$VERSION-sane-settable.patch ../patches

rm -rf ./sane-backends-$VERSION
rm -rf ./sane-backends-$VERSION-orig
