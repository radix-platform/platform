#!/bin/sh

VERSION=1.11

tar --files-from=file.list -xzvf ../gdbm-$VERSION.tar.gz
mv gdbm-$VERSION gdbm-$VERSION-orig

cp -rf ./gdbm-$VERSION-new ./gdbm-$VERSION

diff -b --unified -Nr  gdbm-$VERSION-orig  gdbm-$VERSION > gdbm-$VERSION.patch

mv gdbm-$VERSION.patch ../patches

rm -rf ./gdbm-$VERSION
rm -rf ./gdbm-$VERSION-orig
