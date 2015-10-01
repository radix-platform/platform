#!/bin/sh

VERSION=4.032

tar --files-from=file.list -xzvf ../DBD-mysql-$VERSION.tar.gz
mv DBD-mysql-$VERSION DBD-mysql-$VERSION-orig

cp -rf ./DBD-mysql-$VERSION-new ./DBD-mysql-$VERSION

diff -b --unified -Nr  DBD-mysql-$VERSION-orig  DBD-mysql-$VERSION > DBD-mysql-$VERSION-i386-stack-chk.patch

mv DBD-mysql-$VERSION-i386-stack-chk.patch ../patches

rm -rf ./DBD-mysql-$VERSION
rm -rf ./DBD-mysql-$VERSION-orig
