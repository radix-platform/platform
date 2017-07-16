#!/bin/sh

VERSION=1.8.10

tar --files-from=file.list -xzvf ../py2cairo-$VERSION.tar.gz
mv pycairo-$VERSION pycairo-$VERSION-orig

cp -rf ./pycairo-$VERSION-new ./pycairo-$VERSION

diff -b --unified -Nr  pycairo-$VERSION-orig  pycairo-$VERSION > pycairo-$VERSION-automake.patch

mv pycairo-$VERSION-automake.patch ../patches

rm -rf ./pycairo-$VERSION
rm -rf ./pycairo-$VERSION-orig
