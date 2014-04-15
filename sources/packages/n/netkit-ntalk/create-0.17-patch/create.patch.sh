#!/bin/sh

VERSION=0.17

tar --files-from=file.list -xzf ../netkit-ntalk-$VERSION.tar.gz
mv netkit-ntalk-$VERSION netkit-ntalk-$VERSION-orig

cp -rf ./netkit-ntalk-$VERSION-new ./netkit-ntalk-$VERSION

diff -b --unified -Nr  netkit-ntalk-$VERSION-orig  netkit-ntalk-$VERSION > netkit-ntalk-$VERSION.patch

mv netkit-ntalk-$VERSION.patch ../patches

rm -rf ./netkit-ntalk-$VERSION
rm -rf ./netkit-ntalk-$VERSION-orig
