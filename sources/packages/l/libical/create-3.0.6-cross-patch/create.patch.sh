#!/bin/sh

VERSION=3.0.6

tar --files-from=file.list -xJvf ../libical-$VERSION.tar.xz
mv libical-$VERSION libical-$VERSION-orig

cp -rf ./libical-$VERSION-new ./libical-$VERSION

diff -b --unified -Nr  libical-$VERSION-orig  libical-$VERSION > libical-$VERSION-cross.patch

mv libical-$VERSION-cross.patch ../patches

rm -rf ./libical-$VERSION
rm -rf ./libical-$VERSION-orig
