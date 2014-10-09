#!/bin/sh

VERSION=4.3.1

tar --files-from=file.list -xzvf ../dhcp-$VERSION.tar.gz
mv dhcp-$VERSION dhcp-$VERSION-orig

cp -rf ./dhcp-$VERSION-new ./dhcp-$VERSION

diff -b --unified -Nr  dhcp-$VERSION-orig  dhcp-$VERSION > dhcp-$VERSION.patch

mv dhcp-$VERSION.patch ../patches

rm -rf ./dhcp-$VERSION
rm -rf ./dhcp-$VERSION-orig
