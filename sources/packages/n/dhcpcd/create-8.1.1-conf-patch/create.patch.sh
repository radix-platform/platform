#!/bin/sh

VERSION=8.1.1

tar --files-from=file.list -xJvf ../dhcpcd-$VERSION.tar.xz
mv dhcpcd-$VERSION dhcpcd-$VERSION-orig

cp -rf ./dhcpcd-$VERSION-new ./dhcpcd-$VERSION

diff -b --unified -Nr  dhcpcd-$VERSION-orig  dhcpcd-$VERSION > dhcpcd-$VERSION-conf.patch

mv dhcpcd-$VERSION-conf.patch ../patches

rm -rf ./dhcpcd-$VERSION
rm -rf ./dhcpcd-$VERSION-orig
