#!/bin/sh

VERSION=1.5.1

tar --files-from=file.list -xzvf ../sysklogd-$VERSION.tar.gz
mv sysklogd-$VERSION sysklogd-$VERSION-orig

cp -rf ./sysklogd-$VERSION-new ./sysklogd-$VERSION

diff -b --unified -Nr  sysklogd-$VERSION-orig  sysklogd-$VERSION > sysklogd-$VERSION-union-wait.patch

mv sysklogd-$VERSION-union-wait.patch ../patches

rm -rf ./sysklogd-$VERSION
rm -rf ./sysklogd-$VERSION-orig
