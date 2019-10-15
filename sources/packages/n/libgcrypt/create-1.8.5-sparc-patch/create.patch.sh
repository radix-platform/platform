#!/bin/sh

VERSION=1.8.5

tar --files-from=file.list -xjvf ../libgcrypt-$VERSION.tar.bz2
mv libgcrypt-$VERSION libgcrypt-$VERSION-orig

cp -rf ./libgcrypt-$VERSION-new ./libgcrypt-$VERSION

diff -b --unified -Nr  libgcrypt-$VERSION-orig  libgcrypt-$VERSION > libgcrypt-$VERSION-sparc.patch

mv libgcrypt-$VERSION-sparc.patch ../patches

rm -rf ./libgcrypt-$VERSION
rm -rf ./libgcrypt-$VERSION-orig
