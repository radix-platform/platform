#!/bin/sh

VERSION=3.2.1

tar --files-from=file.list -xzvf ../libffi-$VERSION.tar.gz
mv libffi-$VERSION libffi-$VERSION-orig

cp -rf ./libffi-$VERSION-new ./libffi-$VERSION

diff -b --unified -Nr  libffi-$VERSION-orig  libffi-$VERSION > libffi-$VERSION-includedir.patch

mv libffi-$VERSION-includedir.patch ../patches

rm -rf ./libffi-$VERSION
rm -rf ./libffi-$VERSION-orig
