#!/bin/sh

VERSION=2.4.48

tar --files-from=file.list -xzvf ../openldap-$VERSION.tgz
mv openldap-$VERSION openldap-$VERSION-orig

cp -rf ./openldap-$VERSION-new ./openldap-$VERSION

diff -b --unified -Nr  openldap-$VERSION-orig  openldap-$VERSION > openldap-$VERSION-automake.patch

mv openldap-$VERSION-automake.patch ../patches

rm -rf ./openldap-$VERSION
rm -rf ./openldap-$VERSION-orig
