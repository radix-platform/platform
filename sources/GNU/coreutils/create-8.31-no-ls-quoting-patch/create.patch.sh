#!/bin/sh

VERSION=8.31

tar --files-from=file.list -xJvf ../coreutils-$VERSION.tar.xz
mv coreutils-$VERSION coreutils-$VERSION-orig

cp -rf ./coreutils-$VERSION-new ./coreutils-$VERSION

diff -b --unified -Nr  coreutils-$VERSION-orig  coreutils-$VERSION > coreutils-$VERSION-no-ls-quoting.patch

mv coreutils-$VERSION-no-ls-quoting.patch ../patches

rm -rf ./coreutils-$VERSION
rm -rf ./coreutils-$VERSION-orig