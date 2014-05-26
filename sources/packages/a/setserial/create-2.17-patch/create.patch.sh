#!/bin/sh

VERSION=2.17

tar --files-from=file.list -xzvf ../setserial-$VERSION.tar.gz
mv setserial-$VERSION setserial-$VERSION-orig

cp -rf ./setserial-$VERSION-new ./setserial-$VERSION

diff -b --unified -Nr  setserial-$VERSION-orig  setserial-$VERSION > setserial-$VERSION.patch

mv setserial-$VERSION.patch ../patches

rm -rf ./setserial-$VERSION
rm -rf ./setserial-$VERSION-orig
