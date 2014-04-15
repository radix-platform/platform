#!/bin/sh

VERSION=none

tar --files-from=file.list -xzf ../netdate.tar.gz
mv netdate netdate-orig

cp -rf ./netdate-new ./netdate

diff --unified -Nr  netdate-orig  netdate > netdate.patch

mv netdate.patch ../patches

rm -rf ./netdate
rm -rf ./netdate-orig
