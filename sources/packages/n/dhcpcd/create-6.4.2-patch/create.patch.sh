#!/bin/sh

VERSION=6.4.2

tar --files-from=file.list -xjvf ../dhcpcd-$VERSION.tar.bz2
mv dhcpcd-$VERSION dhcpcd-$VERSION-orig

cp -rf ./dhcpcd-$VERSION-new ./dhcpcd-$VERSION

diff -b --unified -Nr  dhcpcd-$VERSION-orig  dhcpcd-$VERSION > dhcpcd-$VERSION.patch

mv dhcpcd-$VERSION.patch ../patches

rm -rf ./dhcpcd-$VERSION
rm -rf ./dhcpcd-$VERSION-orig
