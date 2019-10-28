#!/bin/sh

VERSION=2.2.6

tar --files-from=file.list -xJvf ../guile-$VERSION.tar.xz
mv guile-$VERSION guile-$VERSION-orig

cp -rf ./guile-$VERSION-new ./guile-$VERSION

diff -b --unified -Nr  guile-$VERSION-orig  guile-$VERSION > guile-$VERSION-cross.patch

mv guile-$VERSION-cross.patch ../patches

rm -rf ./guile-$VERSION
rm -rf ./guile-$VERSION-orig
