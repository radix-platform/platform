#!/bin/sh

VERSION=10.0.25

tar --files-from=file.list -xzvf ../mariadb-$VERSION.tar.gz
mv mariadb-$VERSION mariadb-$VERSION-orig

cp -rf ./mariadb-$VERSION-new ./mariadb-$VERSION

diff -b --unified -Nr  mariadb-$VERSION-orig  mariadb-$VERSION > mariadb-$VERSION-bindir.patch

mv mariadb-$VERSION-bindir.patch ../patches

rm -rf ./mariadb-$VERSION
rm -rf ./mariadb-$VERSION-orig
