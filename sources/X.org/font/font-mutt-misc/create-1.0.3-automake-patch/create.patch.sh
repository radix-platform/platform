#!/bin/sh

VERSION=1.0.3

tar --files-from=file.list -xjvf ../font-mutt-misc-$VERSION.tar.bz2
mv font-mutt-misc-$VERSION font-mutt-misc-$VERSION-orig

cp -rf ./font-mutt-misc-$VERSION-new ./font-mutt-misc-$VERSION

diff -b --unified -Nr  font-mutt-misc-$VERSION-orig  font-mutt-misc-$VERSION > font-mutt-misc-$VERSION-automake.patch

mv font-mutt-misc-$VERSION-automake.patch ../patches

rm -rf ./font-mutt-misc-$VERSION
rm -rf ./font-mutt-misc-$VERSION-orig
