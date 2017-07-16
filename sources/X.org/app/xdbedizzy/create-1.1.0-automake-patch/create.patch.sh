#!/bin/sh

VERSION=1.1.0

tar --files-from=file.list -xjvf ../xdbedizzy-$VERSION.tar.bz2
mv xdbedizzy-$VERSION xdbedizzy-$VERSION-orig

cp -rf ./xdbedizzy-$VERSION-new ./xdbedizzy-$VERSION

diff -b --unified -Nr  xdbedizzy-$VERSION-orig  xdbedizzy-$VERSION > xdbedizzy-$VERSION-automake.patch

mv xdbedizzy-$VERSION-automake.patch ../patches

rm -rf ./xdbedizzy-$VERSION
rm -rf ./xdbedizzy-$VERSION-orig
