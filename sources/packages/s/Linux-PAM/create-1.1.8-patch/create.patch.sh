#!/bin/sh

VERSION=1.1.8

tar --files-from=file.list -xjvf ../Linux-PAM-$VERSION.tar.bz2
mv Linux-PAM-$VERSION Linux-PAM-$VERSION-orig

cp -rf ./Linux-PAM-$VERSION-new ./Linux-PAM-$VERSION

diff -b --unified -Nr  Linux-PAM-$VERSION-orig  Linux-PAM-$VERSION > Linux-PAM-$VERSION.patch

mv Linux-PAM-$VERSION.patch ../patches

rm -rf ./Linux-PAM-$VERSION
rm -rf ./Linux-PAM-$VERSION-orig
