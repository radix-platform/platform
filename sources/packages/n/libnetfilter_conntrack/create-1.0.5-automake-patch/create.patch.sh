#!/bin/sh

VERSION=1.0.5

tar --files-from=file.list -xjvf ../libnetfilter_conntrack-$VERSION.tar.bz2
mv libnetfilter_conntrack-$VERSION libnetfilter_conntrack-$VERSION-orig

cp -rf ./libnetfilter_conntrack-$VERSION-new ./libnetfilter_conntrack-$VERSION

diff -b --unified -Nr  libnetfilter_conntrack-$VERSION-orig  libnetfilter_conntrack-$VERSION > libnetfilter_conntrack-$VERSION-automake.patch

mv libnetfilter_conntrack-$VERSION-automake.patch ../patches

rm -rf ./libnetfilter_conntrack-$VERSION
rm -rf ./libnetfilter_conntrack-$VERSION-orig
