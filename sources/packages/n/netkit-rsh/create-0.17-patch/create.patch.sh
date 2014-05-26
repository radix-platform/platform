#!/bin/sh

VERSION=0.17

tar --files-from=file.list -xzvf ../netkit-rsh-$VERSION.tar.gz
mv netkit-rsh-$VERSION netkit-rsh-$VERSION-orig

cp -rf ./netkit-rsh-$VERSION-new ./netkit-rsh-$VERSION

diff -b --unified -Nr  netkit-rsh-$VERSION-orig  netkit-rsh-$VERSION > netkit-rsh-$VERSION.patch

mv netkit-rsh-$VERSION.patch ../patches

rm -rf ./netkit-rsh-$VERSION
rm -rf ./netkit-rsh-$VERSION-orig
