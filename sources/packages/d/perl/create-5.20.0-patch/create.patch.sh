#!/bin/sh

VERSION=5.20.0

tar --files-from=file.list -xzvf ../perl-$VERSION.tar.gz
mv perl-$VERSION perl-$VERSION-orig

cp -rf ./perl-$VERSION-new ./perl-$VERSION

diff -b --unified -Nr  perl-$VERSION-orig  perl-$VERSION > perl-$VERSION.patch

mv perl-$VERSION.patch ../patches

rm -rf ./perl-$VERSION
rm -rf ./perl-$VERSION-orig
