#!/bin/sh

VERSION=1.1.1

tar --files-from=file.list -xjvf ../evieext-$VERSION.tar.bz2
mv evieext-$VERSION evieext-$VERSION-orig

cp -rf ./evieext-$VERSION-new ./evieext-$VERSION

diff -b --unified -Nr  evieext-$VERSION-orig  evieext-$VERSION > evieext-$VERSION-automake.patch

mv evieext-$VERSION-automake.patch ../patches

rm -rf ./evieext-$VERSION
rm -rf ./evieext-$VERSION-orig
