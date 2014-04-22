#!/bin/sh

VERSION=20020321

NETKIT_VERSION=0.17

mkdir -p netkit-telnet-$NETKIT_VERSION
tar -C netkit-telnet-$NETKIT_VERSION --files-from=file.list -xzf ../telnet-OpenBSD-$VERSION.tar.gz
mv netkit-telnet-$NETKIT_VERSION netkit-telnet-$NETKIT_VERSION-orig

cp -rf ./netkit-telnet-$NETKIT_VERSION-new ./netkit-telnet-$NETKIT_VERSION

diff -b --unified -Nr  netkit-telnet-$NETKIT_VERSION-orig  netkit-telnet-$NETKIT_VERSION > telnet-OpenBSD-$VERSION.patch

mv telnet-OpenBSD-$VERSION.patch ../patches

rm -rf ./netkit-telnet-$NETKIT_VERSION
rm -rf ./netkit-telnet-$NETKIT_VERSION-orig
