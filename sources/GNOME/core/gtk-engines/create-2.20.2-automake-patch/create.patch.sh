#!/bin/sh

VERSION=2.20.2

tar --files-from=file.list -xjvf ../gtk-engines-$VERSION.tar.bz2
mv gtk-engines-$VERSION gtk-engines-$VERSION-orig

cp -rf ./gtk-engines-$VERSION-new ./gtk-engines-$VERSION

diff -b --unified -Nr  gtk-engines-$VERSION-orig  gtk-engines-$VERSION > gtk-engines-$VERSION-automake.patch

mv gtk-engines-$VERSION-automake.patch ../patches

rm -rf ./gtk-engines-$VERSION
rm -rf ./gtk-engines-$VERSION-orig
