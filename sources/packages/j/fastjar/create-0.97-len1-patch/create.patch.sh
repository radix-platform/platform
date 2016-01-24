#!/bin/sh

VERSION=0.97

tar --files-from=file.list -xzvf ../fastjar-$VERSION.tar.gz
mv fastjar-$VERSION fastjar-$VERSION-orig

cp -rf ./fastjar-$VERSION-new ./fastjar-$VERSION

diff -b --unified -Nr  fastjar-$VERSION-orig  fastjar-$VERSION > fastjar-$VERSION-len1.patch

mv fastjar-$VERSION-len1.patch ../patches

rm -rf ./fastjar-$VERSION
rm -rf ./fastjar-$VERSION-orig
