#!/bin/sh

VERSION=5.30.0

tar --files-from=file.list -xJvf ../perl-cross-$VERSION.tar.xz
mv perl-$VERSION perl-$VERSION-orig

cp -rf ./perl-$VERSION-new ./perl-$VERSION

diff -b --unified -Nr  perl-$VERSION-orig  perl-$VERSION > perl-cross-$VERSION.patch

mv perl-cross-$VERSION.patch ../patches

rm -rf ./perl-$VERSION
rm -rf ./perl-$VERSION-orig
