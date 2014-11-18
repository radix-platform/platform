#!/bin/sh

VERSION=2.72

tar --files-from=file.list -xzvf ../dnsmasq-$VERSION.tar.gz
mv dnsmasq-$VERSION dnsmasq-$VERSION-orig

cp -rf ./dnsmasq-$VERSION-new ./dnsmasq-$VERSION

diff -b --unified -Nr  dnsmasq-$VERSION-orig  dnsmasq-$VERSION > dnsmasq-$VERSION.patch

mv dnsmasq-$VERSION.patch ../patches

rm -rf ./dnsmasq-$VERSION
rm -rf ./dnsmasq-$VERSION-orig
