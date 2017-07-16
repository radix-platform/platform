#!/bin/sh

VERSION=1.0.1

tar --files-from=file.list -xjvf ../libnetfilter_log-$VERSION.tar.bz2
mv libnetfilter_log-$VERSION libnetfilter_log-$VERSION-orig

cp -rf ./libnetfilter_log-$VERSION-new ./libnetfilter_log-$VERSION

diff -b --unified -Nr  libnetfilter_log-$VERSION-orig  libnetfilter_log-$VERSION > libnetfilter_log-$VERSION-automake.patch

mv libnetfilter_log-$VERSION-automake.patch ../patches

rm -rf ./libnetfilter_log-$VERSION
rm -rf ./libnetfilter_log-$VERSION-orig
