#!/bin/sh

VERSION=1.11

tar --files-from=file.list -xjvf ../xorg-sgml-doctools-$VERSION.tar.bz2
mv xorg-sgml-doctools-$VERSION xorg-sgml-doctools-$VERSION-orig

cp -rf ./xorg-sgml-doctools-$VERSION-new ./xorg-sgml-doctools-$VERSION

diff -b --unified -Nr  xorg-sgml-doctools-$VERSION-orig  xorg-sgml-doctools-$VERSION > xorg-sgml-doctools-$VERSION-automake.patch

mv xorg-sgml-doctools-$VERSION-automake.patch ../patches

rm -rf ./xorg-sgml-doctools-$VERSION
rm -rf ./xorg-sgml-doctools-$VERSION-orig
