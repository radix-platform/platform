#!/bin/sh

VERSION=0.17

tar --files-from=file.list -xzvf ../netkit-ftp-$VERSION.tar.gz
mv netkit-ftp-$VERSION netkit-ftp-$VERSION-orig

cp -rf ./netkit-ftp-$VERSION-new ./netkit-ftp-$VERSION

diff -b --unified -Nr  netkit-ftp-$VERSION-orig  netkit-ftp-$VERSION > netkit-ftp-$VERSION.patch

mv netkit-ftp-$VERSION.patch ../patches

rm -rf ./netkit-ftp-$VERSION
rm -rf ./netkit-ftp-$VERSION-orig
