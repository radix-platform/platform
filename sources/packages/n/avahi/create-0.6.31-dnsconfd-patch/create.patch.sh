#!/bin/sh

VERSION=0.6.31

tar --files-from=file.list -xzvf ../avahi-$VERSION.tar.gz
mv avahi-$VERSION avahi-$VERSION-orig

cp -rf ./avahi-$VERSION-new ./avahi-$VERSION

diff -Nur  avahi-$VERSION-orig  avahi-$VERSION > avahi-$VERSION-dnsconfd.patch

mv avahi-$VERSION-dnsconfd.patch ../patches

rm -rf ./avahi-$VERSION
rm -rf ./avahi-$VERSION-orig
