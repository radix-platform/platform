#!/bin/sh

VERSION=5.7.3

tar --files-from=file.list -xzvf ../net-snmp-$VERSION.tar.gz
mv net-snmp-$VERSION net-snmp-$VERSION-orig

cp -rf ./net-snmp-$VERSION-new ./net-snmp-$VERSION

diff -b --unified -Nr  net-snmp-$VERSION-orig  net-snmp-$VERSION > net-snmp-$VERSION.patch

mv net-snmp-$VERSION.patch ../patches

rm -rf ./net-snmp-$VERSION
rm -rf ./net-snmp-$VERSION-orig
