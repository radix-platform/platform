#!/bin/sh

VERSION=2.1.0b

tar --files-from=file.list -xzvf ../getty_ps-$VERSION.tar.gz
mv getty_ps-$VERSION getty_ps-$VERSION-orig

cp -rf ./getty_ps-$VERSION-new ./getty_ps-$VERSION

diff -b --unified -Nr  getty_ps-$VERSION-orig getty_ps-$VERSION > getty_ps-$VERSION.patch

mv getty_ps-$VERSION.patch ../patches

rm -rf ./getty_ps-$VERSION
rm -rf ./getty_ps-$VERSION-orig
