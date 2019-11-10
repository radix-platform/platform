#!/bin/sh

VERSION=1.20.0

tar --files-from=file.list -xJvf ../libmbim-$VERSION.tar.xz
mv libmbim-$VERSION libmbim-$VERSION-orig

cp -rf ./libmbim-$VERSION-new ./libmbim-$VERSION

diff -b --unified -Nr  libmbim-$VERSION-orig  libmbim-$VERSION > libmbim-$VERSION-gtkdoc.patch

mv libmbim-$VERSION-gtkdoc.patch ../patches

rm -rf ./libmbim-$VERSION
rm -rf ./libmbim-$VERSION-orig
