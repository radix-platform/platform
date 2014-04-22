#!/bin/sh

VERSION=0.17

tar --files-from=file.list -xzf ../netkit-telnet-$VERSION.tar.gz
mv netkit-telnet-$VERSION netkit-telnet-$VERSION-orig

cp -rf ./netkit-telnet-$VERSION-new ./netkit-telnet-$VERSION

diff -b --unified -Nr  netkit-telnet-$VERSION-orig  netkit-telnet-$VERSION > netkit-telnet-$VERSION-telnetd.patch

mv netkit-telnet-$VERSION-telnetd.patch ../patches

rm -rf ./netkit-telnet-$VERSION
rm -rf ./netkit-telnet-$VERSION-orig
