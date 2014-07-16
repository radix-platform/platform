#!/bin/sh

VERSION=2.9.1

tar --files-from=file.list -xjvf ../pam_unix2-$VERSION.tar.bz2
mv pam_unix2-$VERSION pam_unix2-$VERSION-orig

cp -rf ./pam_unix2-$VERSION-new ./pam_unix2-$VERSION

diff -b --unified -Nr  pam_unix2-$VERSION-orig  pam_unix2-$VERSION > pam_unix2-$VERSION-glibc216.patch

mv pam_unix2-$VERSION-glibc216.patch ../patches

rm -rf ./pam_unix2-$VERSION
rm -rf ./pam_unix2-$VERSION-orig
