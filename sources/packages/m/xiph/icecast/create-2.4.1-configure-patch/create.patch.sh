#!/bin/sh

VERSION=2.4.1

tar --files-from=file.list -xzvf ../icecast-$VERSION.tar.gz
mv icecast-$VERSION icecast-$VERSION-orig

cp -rf ./icecast-$VERSION-new ./icecast-$VERSION

diff -b --unified -Nr  icecast-$VERSION-orig  icecast-$VERSION > icecast-$VERSION-configure.patch

mv icecast-$VERSION-configure.patch ../patches

rm -rf ./icecast-$VERSION
rm -rf ./icecast-$VERSION-orig
