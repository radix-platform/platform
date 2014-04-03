#!/bin/sh

VERSION=7.6

tar --files-from=file.list -xzf ../tcp_wrappers_$VERSION.tar.gz
( cd tcp_wrappers_$VERSION ; chmod +w * )
mv tcp_wrappers_$VERSION tcp_wrappers_$VERSION-orig

cp -rf ./tcp_wrappers_$VERSION-new ./tcp_wrappers_$VERSION

diff -b --unified -Nr  tcp_wrappers_$VERSION-orig  tcp_wrappers_$VERSION > tcp_wrappers_$VERSION.patch

mv tcp_wrappers_$VERSION.patch ../patches

rm -rf ./tcp_wrappers_$VERSION
rm -rf ./tcp_wrappers_$VERSION-orig
