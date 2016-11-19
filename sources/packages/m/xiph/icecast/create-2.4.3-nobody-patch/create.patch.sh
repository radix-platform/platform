#!/bin/sh

VERSION=2.4.3

tar --files-from=file.list -xzvf ../icecast-$VERSION.tar.gz
mv icecast-$VERSION icecast-$VERSION-orig

cp -rf ./icecast-$VERSION-new ./icecast-$VERSION

diff -b --unified -Nr  icecast-$VERSION-orig  icecast-$VERSION > icecast-$VERSION-nobody.patch

mv icecast-$VERSION-nobody.patch ../patches

rm -rf ./icecast-$VERSION
rm -rf ./icecast-$VERSION-orig
