#!/bin/sh

VERSION=1.3.4

tar --files-from=file.list -xjvf ../xinit-$VERSION.tar.bz2
mv xinit-$VERSION xinit-$VERSION-orig

cp -rf ./xinit-$VERSION-new ./xinit-$VERSION

diff -b --unified -Nr  xinit-$VERSION-orig  xinit-$VERSION > xinit-$VERSION-remove-systemd-kludge.patch

mv xinit-$VERSION-remove-systemd-kludge.patch ../patches

rm -rf ./xinit-$VERSION
rm -rf ./xinit-$VERSION-orig
