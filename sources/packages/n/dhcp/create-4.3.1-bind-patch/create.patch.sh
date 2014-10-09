#!/bin/sh

VERSION=4.3.1

tar --files-from=dhcp.file.list -xzvf ../dhcp-$VERSION.tar.gz
( cd dhcp-$VERSION/bind ; tar --files-from=../../dhcp-bind.file.list -xzvf bind.tar.gz ; rm -f bind.tar.gz )
mv dhcp-$VERSION dhcp-$VERSION-orig

cp -rf ./dhcp-$VERSION-new ./dhcp-$VERSION

diff -b --unified -Nr  dhcp-$VERSION-orig  dhcp-$VERSION > dhcp-$VERSION-bind.patch

mv dhcp-$VERSION-bind.patch ../patches

rm -rf ./dhcp-$VERSION
rm -rf ./dhcp-$VERSION-orig
