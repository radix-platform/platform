#!/bin/sh

VERSION=3.6.27

tar --files-from=file.list -xJvf ../reiserfsprogs-$VERSION.tar.xz
mv reiserfsprogs-$VERSION reiserfsprogs-$VERSION-orig

cp -rf ./reiserfsprogs-$VERSION-new ./reiserfsprogs-$VERSION

diff -b --unified -Nr  reiserfsprogs-$VERSION-orig  reiserfsprogs-$VERSION > reiserfsprogs-$VERSION-glibc228.patch

mv reiserfsprogs-$VERSION-glibc228.patch ../patches

rm -rf ./reiserfsprogs-$VERSION
rm -rf ./reiserfsprogs-$VERSION-orig
