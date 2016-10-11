#!/bin/sh

VERSION=9.6.0

tar --files-from=file.list -xjvf ../postgresql-$VERSION.tar.bz2
mv postgresql-$VERSION postgresql-$VERSION-orig

cp -rf ./postgresql-$VERSION-new ./postgresql-$VERSION

diff -b --unified -Nr  postgresql-$VERSION-orig  postgresql-$VERSION > postgresql-$VERSION-configure.patch

mv postgresql-$VERSION-configure.patch ../patches

rm -rf ./postgresql-$VERSION
rm -rf ./postgresql-$VERSION-orig
