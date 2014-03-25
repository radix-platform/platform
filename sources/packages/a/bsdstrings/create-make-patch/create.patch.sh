#!/bin/sh

VERSION=none

tar --files-from=file.list -xzf ../bsdstrings.tar.gz
mv bsdstrings bsdstrings-orig

cp -rf ./bsdstrings-new ./bsdstrings

diff -b --unified -Nr  bsdstrings-orig  bsdstrings > bsdstrings.patch

mv bsdstrings.patch ../patches

rm -rf ./bsdstrings
rm -rf ./bsdstrings-orig
