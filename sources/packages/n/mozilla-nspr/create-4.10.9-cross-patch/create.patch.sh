#!/bin/sh

VERSION=4.10.9

tar --files-from=file.list -xJvf ../nspr-$VERSION.tar.xz
mv nspr-$VERSION nspr-$VERSION-orig

cp -rf ./nspr-$VERSION-new ./nspr-$VERSION

diff -b --unified -Nr  nspr-$VERSION-orig  nspr-$VERSION > nspr-$VERSION-cross.patch

mv nspr-$VERSION-cross.patch ../patches

rm -rf ./nspr-$VERSION
rm -rf ./nspr-$VERSION-orig
