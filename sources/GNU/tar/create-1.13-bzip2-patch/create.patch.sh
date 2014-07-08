#!/bin/sh

VERSION=1.13

tar --files-from=file.list -xzvf ../tar-$VERSION.tar.gz
mv tar-$VERSION tar-$VERSION-orig

cp -rf ./tar-$VERSION-new ./tar-$VERSION

diff -b --unified -Nr  tar-$VERSION-orig  tar-$VERSION > tar-$VERSION-bzip2.patch

mv tar-$VERSION-bzip2.patch ../patches

rm -rf ./tar-$VERSION
rm -rf ./tar-$VERSION-orig
