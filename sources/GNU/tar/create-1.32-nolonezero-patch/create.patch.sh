#!/bin/sh

VERSION=1.32

tar --files-from=file.list -xJvf ../tar-$VERSION.tar.xz
mv tar-$VERSION tar-$VERSION-orig

cp -rf ./tar-$VERSION-new ./tar-$VERSION

diff -b --unified -Nr  tar-$VERSION-orig  tar-$VERSION > tar-$VERSION-nolonezero.patch

mv tar-$VERSION-nolonezero.patch ../patches

rm -rf ./tar-$VERSION
rm -rf ./tar-$VERSION-orig
