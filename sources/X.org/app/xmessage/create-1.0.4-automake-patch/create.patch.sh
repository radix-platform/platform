#!/bin/sh

VERSION=1.0.4

tar --files-from=file.list -xjvf ../xmessage-$VERSION.tar.bz2
mv xmessage-$VERSION xmessage-$VERSION-orig

cp -rf ./xmessage-$VERSION-new ./xmessage-$VERSION

diff -b --unified -Nr  xmessage-$VERSION-orig  xmessage-$VERSION > xmessage-$VERSION-automake.patch

mv xmessage-$VERSION-automake.patch ../patches

rm -rf ./xmessage-$VERSION
rm -rf ./xmessage-$VERSION-orig
