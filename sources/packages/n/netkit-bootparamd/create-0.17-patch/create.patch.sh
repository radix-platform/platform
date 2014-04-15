#!/bin/sh

VERSION=0.17

tar --files-from=file.list -xzf ../netkit-bootparamd-$VERSION.tar.gz
mv netkit-bootparamd-$VERSION netkit-bootparamd-$VERSION-orig

cp -rf ./netkit-bootparamd-$VERSION-new ./netkit-bootparamd-$VERSION

diff -b --unified -Nr  netkit-bootparamd-$VERSION-orig  netkit-bootparamd-$VERSION > netkit-bootparamd-$VERSION.patch

mv netkit-bootparamd-$VERSION.patch ../patches

rm -rf ./netkit-bootparamd-$VERSION
rm -rf ./netkit-bootparamd-$VERSION-orig
