#!/bin/sh

VERSION=1.2.1

tar --files-from=file.list -xjvf ../damageproto-$VERSION.tar.bz2
mv damageproto-$VERSION damageproto-$VERSION-orig

cp -rf ./damageproto-$VERSION-new ./damageproto-$VERSION

diff -b --unified -Nr  damageproto-$VERSION-orig  damageproto-$VERSION > damageproto-$VERSION-automake.patch

mv damageproto-$VERSION-automake.patch ../patches

rm -rf ./damageproto-$VERSION
rm -rf ./damageproto-$VERSION-orig
