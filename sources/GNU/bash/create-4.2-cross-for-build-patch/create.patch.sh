#!/bin/sh

VERSION=4.2

tar --files-from=file.list -xzvf ../bash-$VERSION.tar.gz
mv bash-$VERSION bash-$VERSION-orig

cp -rf ./bash-$VERSION-new ./bash-$VERSION

diff -b --unified -Nr  bash-$VERSION-orig  bash-$VERSION > bash-$VERSION-cross-for-build.patch

mv bash-$VERSION-cross-for-build.patch ../patches

rm -rf ./bash-$VERSION
rm -rf ./bash-$VERSION-orig
