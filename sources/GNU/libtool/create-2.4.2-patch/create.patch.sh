#!/bin/sh

VERSION=2.4.2

tar --files-from=file.list -xJvf ../libtool-$VERSION.tar.xz
chmod +w libtool-$VERSION/libltdl/config/ltmain.m4sh
chmod +w libtool-$VERSION/libltdl/config/ltmain.sh
mv libtool-$VERSION libtool-$VERSION-orig

cp -rf ./libtool-$VERSION-new ./libtool-$VERSION

diff -b --unified -Nr  libtool-$VERSION-orig  libtool-$VERSION > libtool-$VERSION-no-moved-warning.patch

mv libtool-$VERSION-no-moved-warning.patch ../patches

rm -rf ./libtool-$VERSION
rm -rf ./libtool-$VERSION-orig
