#!/bin/sh

VERSION=0.8.13

tar --files-from=file.list -xzvf ../libelf-$VERSION.tar.gz
mv libelf-$VERSION libelf-$VERSION-orig

cp -rf ./libelf-$VERSION-new ./libelf-$VERSION

diff -b --unified -Nr  libelf-$VERSION-orig  libelf-$VERSION > libelf-$VERSION-cross.patch

mv libelf-$VERSION-cross.patch ../patches

rm -rf ./libelf-$VERSION
rm -rf ./libelf-$VERSION-orig
