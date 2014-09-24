#!/bin/sh

VERSION=none

tar --files-from=file.list -xzvf ../banners.tar.gz
mv banners banners-orig

cp -rf ./banners-new ./banners

diff -b --unified -Nr  banners-orig  banners > banners.patch

mv banners.patch ../patches

rm -rf ./banners
rm -rf ./banners-orig
