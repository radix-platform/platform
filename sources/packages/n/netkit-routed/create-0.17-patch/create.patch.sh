#!/bin/sh

VERSION=0.17

tar --files-from=file.list -xzf ../netkit-routed-$VERSION.tar.gz
mv netkit-routed-$VERSION netkit-routed-$VERSION-orig

cp -rf ./netkit-routed-$VERSION-new ./netkit-routed-$VERSION

diff -b --unified -Nr  netkit-routed-$VERSION-orig  netkit-routed-$VERSION > netkit-routed-$VERSION.patch

mv netkit-routed-$VERSION.patch ../patches

rm -rf ./netkit-routed-$VERSION
rm -rf ./netkit-routed-$VERSION-orig
