#!/bin/sh

VERSION=3.6.24

tar --files-from=file.list -xJvf ../reiserfsprogs-$VERSION.tar.xz
mv reiserfsprogs-$VERSION reiserfsprogs-$VERSION-orig

cp -rf ./reiserfsprogs-$VERSION-new ./reiserfsprogs-$VERSION

diff -b --unified -Nr  reiserfsprogs-$VERSION-orig  reiserfsprogs-$VERSION > reiserfsprogs-$VERSION-man.patch

mv reiserfsprogs-$VERSION-man.patch ../patches

rm -rf ./reiserfsprogs-$VERSION
rm -rf ./reiserfsprogs-$VERSION-orig
