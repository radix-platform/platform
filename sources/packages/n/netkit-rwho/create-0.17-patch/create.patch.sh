#!/bin/sh

VERSION=0.17

tar --files-from=file.list -xzvf ../netkit-rwho-$VERSION.tar.gz
mv netkit-rwho-$VERSION netkit-rwho-$VERSION-orig

cp -rf ./netkit-rwho-$VERSION-new ./netkit-rwho-$VERSION

diff -b --unified -Nr  netkit-rwho-$VERSION-orig  netkit-rwho-$VERSION > netkit-rwho-$VERSION.patch

mv netkit-rwho-$VERSION.patch ../patches

rm -rf ./netkit-rwho-$VERSION
rm -rf ./netkit-rwho-$VERSION-orig
