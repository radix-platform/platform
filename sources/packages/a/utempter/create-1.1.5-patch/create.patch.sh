#!/bin/sh

VERSION=1.1.5

tar --files-from=file.list -xjvf ../libutempter-$VERSION.tar.bz2
mv libutempter-$VERSION libutempter-$VERSION-orig

cp -rf ./libutempter-$VERSION-new ./libutempter-$VERSION

diff -b --unified -Nr  libutempter-$VERSION-orig  libutempter-$VERSION > libutempter-$VERSION.patch

mv libutempter-$VERSION.patch ../patches

rm -rf ./libutempter-$VERSION
rm -rf ./libutempter-$VERSION-orig
