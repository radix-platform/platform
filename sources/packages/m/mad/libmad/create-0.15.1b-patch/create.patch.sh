#!/bin/sh

VERSION=0.15.1b

tar --files-from=file.list -xzvf ../libmad-$VERSION.tar.gz
mv libmad-$VERSION libmad-$VERSION-orig

cp -rf ./libmad-$VERSION-new ./libmad-$VERSION

diff -b --unified -Nr  libmad-$VERSION-orig  libmad-$VERSION > libmad-$VERSION.patch

mv libmad-$VERSION.patch ../patches

rm -rf ./libmad-$VERSION
rm -rf ./libmad-$VERSION-orig
