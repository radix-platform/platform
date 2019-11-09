#!/bin/sh

VERSION=4.4.1

tar --files-from=file.list -xzvf ../dhcp-$VERSION.tar.gz
mv dhcp-$VERSION dhcp-$VERSION-orig

cp -rf ./dhcp-$VERSION-new ./dhcp-$VERSION

diff -b --unified -Nr  dhcp-$VERSION-orig  dhcp-$VERSION > dhcp-$VERSION-path.patch

mv dhcp-$VERSION-path.patch ../patches

rm -rf ./dhcp-$VERSION
rm -rf ./dhcp-$VERSION-orig
