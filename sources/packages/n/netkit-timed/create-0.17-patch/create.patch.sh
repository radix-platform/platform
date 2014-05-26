#!/bin/sh

VERSION=0.17

tar --files-from=file.list -xzvf ../netkit-timed-$VERSION.tar.gz
mv netkit-timed-$VERSION netkit-timed-$VERSION-orig

cp -rf ./netkit-timed-$VERSION-new ./netkit-timed-$VERSION

diff -b --unified -Nr  netkit-timed-$VERSION-orig  netkit-timed-$VERSION > netkit-timed-$VERSION.patch

mv netkit-timed-$VERSION.patch ../patches

rm -rf ./netkit-timed-$VERSION
rm -rf ./netkit-timed-$VERSION-orig
