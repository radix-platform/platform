#!/bin/sh

VERSION=2.0.26

tar --files-from=file.list -xJvf ../acpid-$VERSION.tar.xz
mv acpid-$VERSION acpid-$VERSION-orig

cp -rf ./acpid-$VERSION-new ./acpid-$VERSION

diff -b --unified -Nr  acpid-$VERSION-orig  acpid-$VERSION > acpid-$VERSION-rpl-malloc.patch

mv acpid-$VERSION-rpl-malloc.patch ../patches

rm -rf ./acpid-$VERSION
rm -rf ./acpid-$VERSION-orig
