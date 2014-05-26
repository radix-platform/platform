#!/bin/sh

VERSION=1.79

tar --files-from=file.list -xzvf ../inetd-OpenBSD-$VERSION.tar.gz
mv inetd inetd-orig

cp -rf ./inetd-new ./inetd

diff -b --unified -Nr  inetd-orig  inetd > inetd-OpenBSD-$VERSION.patch

mv inetd-OpenBSD-$VERSION.patch ../patches

rm -rf ./inetd
rm -rf ./inetd-orig
