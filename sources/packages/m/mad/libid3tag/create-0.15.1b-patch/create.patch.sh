#!/bin/sh

VERSION=0.15.1b

tar --files-from=file.list -xzvf ../libid3tag-$VERSION.tar.gz
mv libid3tag-$VERSION libid3tag-$VERSION-orig

cp -rf ./libid3tag-$VERSION-new ./libid3tag-$VERSION

diff -b --unified -Nr  libid3tag-$VERSION-orig  libid3tag-$VERSION > libid3tag-$VERSION.patch

mv libid3tag-$VERSION.patch ../patches

rm -rf ./libid3tag-$VERSION
rm -rf ./libid3tag-$VERSION-orig
