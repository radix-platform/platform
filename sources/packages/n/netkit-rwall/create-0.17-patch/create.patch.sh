#!/bin/sh

VERSION=0.17

tar --files-from=file.list -xzf ../netkit-rwall-$VERSION.tar.gz
mv netkit-rwall-$VERSION netkit-rwall-$VERSION-orig

cp -rf ./netkit-rwall-$VERSION-new ./netkit-rwall-$VERSION

diff -b --unified -Nr  netkit-rwall-$VERSION-orig  netkit-rwall-$VERSION > netkit-rwall-$VERSION.patch

mv netkit-rwall-$VERSION.patch ../patches

rm -rf ./netkit-rwall-$VERSION
rm -rf ./netkit-rwall-$VERSION-orig
