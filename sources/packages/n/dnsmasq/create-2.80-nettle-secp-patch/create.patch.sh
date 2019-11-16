#!/bin/sh

VERSION=2.80

tar --files-from=file.list -xJvf ../dnsmasq-$VERSION.tar.xz
mv dnsmasq-$VERSION dnsmasq-$VERSION-orig

cp -rf ./dnsmasq-$VERSION-new ./dnsmasq-$VERSION

diff -b --unified -Nr  dnsmasq-$VERSION-orig  dnsmasq-$VERSION > dnsmasq-$VERSION-nettle-secp.patch

mv dnsmasq-$VERSION-nettle-secp.patch ../patches

rm -rf ./dnsmasq-$VERSION
rm -rf ./dnsmasq-$VERSION-orig
