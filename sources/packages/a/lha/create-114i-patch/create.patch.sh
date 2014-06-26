#!/bin/sh

VERSION=114i

tar --files-from=file.list -xzvf ../lha-$VERSION.tar.gz
mv lha-$VERSION lha-$VERSION-orig

cp -rf ./lha-$VERSION-new ./lha-$VERSION

diff -b --unified -Nr  lha-$VERSION-orig lha-$VERSION > lha-$VERSION.patch

mv lha-$VERSION.patch ../patches

rm -rf ./lha-$VERSION
rm -rf ./lha-$VERSION-orig
