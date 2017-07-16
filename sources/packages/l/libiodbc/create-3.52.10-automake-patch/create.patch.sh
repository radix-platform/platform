#!/bin/sh

VERSION=3.52.10

tar --files-from=file.list -xzvf ../libiodbc-$VERSION.tar.gz
mv libiodbc-$VERSION libiodbc-$VERSION-orig

cp -rf ./libiodbc-$VERSION-new ./libiodbc-$VERSION

diff -b --unified -Nr  libiodbc-$VERSION-orig  libiodbc-$VERSION > libiodbc-$VERSION-automake.patch

mv libiodbc-$VERSION-automake.patch ../patches

rm -rf ./libiodbc-$VERSION
rm -rf ./libiodbc-$VERSION-orig
