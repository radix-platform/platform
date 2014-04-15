#!/bin/sh

VERSION=0.17

tar --files-from=file.list -xzf ../netkit-rusers-$VERSION.tar.gz
mv netkit-rusers-$VERSION netkit-rusers-$VERSION-orig

cp -rf ./netkit-rusers-$VERSION-new ./netkit-rusers-$VERSION

diff -b --unified -Nr  netkit-rusers-$VERSION-orig  netkit-rusers-$VERSION > netkit-rusers-$VERSION.patch

mv netkit-rusers-$VERSION.patch ../patches

rm -rf ./netkit-rusers-$VERSION
rm -rf ./netkit-rusers-$VERSION-orig
