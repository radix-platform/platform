#!/bin/sh

VERSION=5.15

tar --files-from=file.list -xzvf ../file-$VERSION.tar.gz
mv file-$VERSION file-$VERSION-orig

cp -rf ./file-$VERSION-new ./file-$VERSION

diff -b --unified -Nr  file-$VERSION-orig file-$VERSION > file-$VERSION.patch

mv file-$VERSION.patch ../patches

rm -rf ./file-$VERSION
rm -rf ./file-$VERSION-orig
